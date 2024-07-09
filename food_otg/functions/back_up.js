// exports.notifyManagerOnOrderPlacement = functions.firestore
//   .document('orders/{orderId}')
//   .onCreate(async (snapshot, context) => {
//     try {
//       const orderData = snapshot.data()
//       const restaurantIds = orderData.resId // Assuming resId is an array

//       console.log(`Order placed: ${snapshot.id}`)
//       console.log(`Restaurant IDs: ${restaurantIds}`)

//       // Fetch user location
//       const userLat = orderData.userLat
//       const userLong = orderData.userLong

//       console.log(`User Location: (${userLat}, ${userLong})`)

//       // Get all managers within 5 km range and matching resId
//       const managersSnapshot = await admin
//         .firestore()
//         .collection('Managers')
//         .get()
//       const notificationPromises = []

//       managersSnapshot.forEach((managerDoc) => {
//         const managerData = managerDoc.data()
//         const managerId = managerDoc.id
//         const managerResId = managerData.resId
//         const fcmToken = managerData.fcmToken

//         // Check if manager's resId matches any of the order's restaurant IDs
//         if (restaurantIds.includes(managerResId)) {
//           // Fetch manager's location
//           const managerLocation = managerData.locationLatLng
//           // Calculate distance between user and manager
//           const distance = calculateDistance(
//             userLat,
//             userLong,
//             managerLocation.latitude,
//             managerLocation.longitude
//           )

//           console.log(`Manager ID: ${managerId}`)
//           console.log(
//             `Manager Location: (${managerLocation.latitude}, ${managerLocation.longitude})`
//           )
//           console.log(`Distance between user and manager: ${distance} km`)

//           // If manager is within 5 km range, send notification
//           if (distance <= 5) {
//             console.log(`Sending notification to manager: ${managerId}`)

//             const payload = {
//               notification: {
//                 title: 'New Order Received',
//                 body: 'A new order has been placed at your restaurant.',
//               },
//               data: {
//                 orderId: context.params.orderId,
//               },
//             }

//             if (fcmToken && payload && object.keys(payload).length !== 0) {
//               notificationPromises.push(
//                 // admin.messaging().sendToDevice(fcmToken, payload)
//                 admin.messaging().send({
//                   data: payload.data,
//                   notification: payload.notification,
//                   token: fcmToken,
//                 })
//               )
//               console.log(`Notification sent to manager: ${managerId}`)
//             } else {
//               console.error(
//                 'Invalid token or payload for managers:',
//                 managerData
//               )
//             }
//           } else {
//             console.log('Manager is not in range. Distance:', distance, 'km')
//           }
//         } else {
//           console.log(
//             'Manger does not have matching resId. Skipping notification.'
//           )
//         }
//       })

//       // Send notifications to all managers within range
//       await Promise.all(notificationPromises)
//       console.log('Notifications sent to nearby Managers.')
//     } catch (error) {
//       console.error('Error occurred:', error)
//     }
//   })
