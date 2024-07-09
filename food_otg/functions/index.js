const functions = require('firebase-functions')
const admin = require('firebase-admin')
const moment = require('moment')

admin.initializeApp()

const calculateDistance = (startLat, startLng, endLat, endLng) => {
  const radius = 6371.0 // Earth's radius in kilometers

  const dLat = toRadians(endLat - startLat)
  const dLng = toRadians(endLng - startLng)

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(startLat)) *
      Math.cos(toRadians(endLat)) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2)

  const c = 2 * Math.asin(Math.sqrt(a))

  return radius * c
}
const toRadians = (degrees) => {
  return degrees * (Math.PI / 180)
}

exports.notifyManagerOnOrderPlacement = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snapshot, context) => {
    try {
      const orderData = snapshot.data()
      const restaurantIds = orderData.resId // Assuming resId is an array

      console.log(`Order placed: ${snapshot.id}`)
      console.log(`Restaurant IDs: ${restaurantIds}`)

      // Fetch user location
      const userLat = orderData.userLat
      const userLong = orderData.userLong

      console.log(`User Location: (${userLat}, ${userLong})`)

      // Get all managers within 5 km range and matching resId
      const managersSnapshot = await admin
        .firestore()
        .collection('Managers')
        .get()
      const notificationPromises = []

      managersSnapshot.forEach((managerDoc) => {
        const managerData = managerDoc.data()
        const managerId = managerDoc.id
        const managerResId = managerData.resId
        const fcmToken = managerData.fcmToken

        // Check if manager's resId matches any of the order's restaurant IDs
        if (restaurantIds.includes(managerResId)) {
          // Fetch manager's location
          const managerLocation = managerData.locationLatLng

          // Calculate distance between user and manager
          const distance = calculateDistance(
            userLat,
            userLong,
            managerLocation.latitude,
            managerLocation.longitude
          )

          console.log(`Manager ID: ${managerId}`)
          console.log(
            `Manager Location: (${managerLocation.latitude}, ${managerLocation.longitude})`
          )
          console.log(`Distance between user and manager: ${distance} km`)

          // If manager is within 5 km range, send notification
          if (distance <= 5) {
            console.log(`Sending notification to manager: ${managerId}`)

            const payload = {
              notification: {
                title: 'New Order Received',
                body: 'A new order has been placed at your restaurant.',
              },
              data: {
                orderId: context.params.orderId,
              },
            }

            if (fcmToken && payload && Object.keys(payload).length !== 0) {
              notificationPromises.push(
                // admin.messaging().sendToDevice(fcmToken, payload)
                admin.messaging().send({
                  data: payload.data,
                  notification: payload.notification,
                  token: fcmToken,
                })
              )
              console.log(`Notification sent to manager: ${managerId}`)
            } else {
              console.error(
                'Invalid token or payload for managers:',
                managerData
              )
            }
          } else {
            console.log('Manager is not in range. Distance:', distance, 'km')
          }
        } else {
          console.log(
            'Manager does not have matching resId. Skipping notification.'
          )
        }
      })

      // Send notifications to all managers within range
      await Promise.all(notificationPromises)
      console.log('Notifications sent to nearby Managers.')

      // Notification payload for customers
      const customerPayload = {
        notification: {},
        data: {
          orderId: context.params.orderId,
        },
      }

      // Update customer payload based on order status
      switch (orderData.status) {
        case 1:
          // Order accepted
          customerPayload.notification.title = 'Order Accepted'
          customerPayload.notification.body = 'Your order is accepted.'
          break
        case 2:
          // Order assigned to delivery partner
          const assignedDriverId = orderData.driverId
          const driverSnapshot = await admin
            .firestore()
            .collection('Drivers')
            .doc(assignedDriverId)
            .get()
          const driverName = driverSnapshot.data().userName
          customerPayload.notification.title = 'Assigned to Delivery Partner'
          customerPayload.notification.body = `Assigned to Delivery Partner ${driverName}`
          break
        case 3:
          // Order is on the way
          customerPayload.notification.title = 'Order on the Way'
          customerPayload.notification.body = 'Your order is on the way.'
          break
        case -1:
          // Order canceled
          customerPayload.notification.title = 'Order Canceled'
          customerPayload.notification.body = 'Your order has been canceled.'
          break
        default:
          // Default notification for other statuses
          customerPayload.notification.title = 'Order Update'
          customerPayload.notification.body = 'Your order has been updated.'
          break
      }

      // Send notification to the customer
      const userId = orderData.userId
      const userSnapshot = await admin
        .firestore()
        .collection('Users')
        .doc(userId)
        .get()
      const userFcmToken = userSnapshot.data().fcmToken

      if (
        userFcmToken &&
        customerPayload &&
        Object.keys(customerPayload).length !== 0
      ) {
        await admin.messaging().sendToDevice(userFcmToken, customerPayload)
        console.log('Notification sent to customer:', userId)
      } else {
        console.error(
          'Invalid token or payload for customer:',
          userSnapshot.data()
        )
      }

      // Notification payload for nearby drivers
      const nearbyDriversPayload = {
        notification: {
          title: 'New Order Available',
          body: 'A new order is available nearby.',
        },
        data: {
          orderId: context.params.orderId,
        },
      }

      // Get all active drivers within 5 km range
      const driversSnapshot = await admin
        .firestore()
        .collection('Drivers')
        .where('active', '==', true)
        .get()

      const driverNotificationPromises = []

      // Send notifications to nearby drivers
      driversSnapshot.forEach((driverDoc) => {
        const driverData = driverDoc.data()
        const driverId = driverDoc.id
        const driverLocation = driverData.locationLatLng
        const driverFcmToken = driverData.fcmToken

        // Calculate distance between user and driver
        const distance = calculateDistance(
          userLat,
          userLong,
          driverLocation.latitude,
          driverLocation.longitude
        )

        console.log(`Driver ID: ${driverId}`)
        console.log(
          `Driver Location: (${driverLocation.latitude}, ${driverLocation.longitude})`
        )
        console.log(`Distance between user and driver: ${distance} km`)

        // If driver is within 5 km range, send notification
        if (distance <= 5) {
          console.log(`Sending notification to driver: ${driverId}`)

          if (
            driverFcmToken &&
            nearbyDriversPayload &&
            Object.keys(nearbyDriversPayload).length !== 0
          ) {
            driverNotificationPromises.push(
              admin
                .messaging()
                .sendToDevice(driverFcmToken, nearbyDriversPayload)
            )
            console.log(`Notification sent to driver: ${driverId}`)
          } else {
            console.error('Invalid token or payload for driver:', driverData)
          }
        } else {
          console.log('Driver is not in range. Distance:', distance, 'km')
        }
      })

      // Send notifications to nearby drivers
      await Promise.all(driverNotificationPromises)
      console.log('Notifications sent to nearby Drivers.')
    } catch (error) {
      console.error('Error occurred:', error)
    }
  })

exports.sendBirthdayAndAnniversaryNotifications = functions.https.onRequest(
  async (req, res) => {
    try {
      // Get current date
      const currentDate = moment().format('MM-DD')

      // Query users whose birthday or anniversary matches the current date
      const usersSnapshot = await admin
        .firestore()
        .collection('Users')
        .where('dob', '==', currentDate)
        .orWhere('anniversary', '==', currentDate)
        .get()

      const notificationPromises = []

      usersSnapshot.forEach((userDoc) => {
        const userData = userDoc.data()
        const userId = userDoc.id
        const userFcmToken = userData.fcmToken

        if (userFcmToken) {
          let notificationTitle = ''
          let notificationBody = ''

          if (userData.dob === currentDate) {
            notificationTitle = 'Happy Birthday!'
            notificationBody = 'Wishing you a fantastic birthday!'
          } else if (userData.anniversary === currentDate) {
            notificationTitle = 'Happy Anniversary!'
            notificationBody = 'Congratulations on your special day!'
          }

          if (notificationTitle && notificationBody) {
            const payload = {
              notification: {
                title: notificationTitle,
                body: notificationBody,
              },
              data: {
                userId: userId,
              },
            }

            notificationPromises.push(
              admin.messaging().sendToDevice(userFcmToken, payload)
            )
            console.log(`Notification sent to user: ${userId}`)
          }
        }
      })

      // Send all notifications
      await Promise.all(notificationPromises)
      console.log('Birthday and anniversary notifications sent successfully.')

      res
        .status(200)
        .send('Birthday and anniversary notifications sent successfully.')
    } catch (error) {
      console.error('Error sending notifications:', error)
      res.status(500).send('Error sending notifications.')
    }
  }
)
