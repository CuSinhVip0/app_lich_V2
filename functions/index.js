const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment-timezone');
admin.initializeApp();
exports.sendEventNotifications = functions.pubsub
  .schedule('every day 23:08') // Chạy hàng ngày lúc 8 giờ sáng
  .timeZone('Asia/Ho_Chi_Minh') // Thiết lập múi giờ
  .onRun(async (context) => {
      const month = moment(new Date()).tz("Asia/Ho_Chi_Minh").format("M");
      const day = moment(new Date()).tz("Asia/Ho_Chi_Minh").format("D");
      const eventsRef = admin.firestore().collection('events');
      const fcmTokensRef = admin.firestore().collection('fcmtokens');
      var eventsSnapshot = await eventsRef.where('Thang', '==',month);
      eventsSnapshot = await eventsSnapshot.where('Ngay', '==',day).get();
      const fcmTokens = await fcmTokensRef.get();
      const messages = [];
      eventsSnapshot.forEach(doc => {
          const event = doc.data();
           fcmTokens.forEach(tokenDoc => {
                const token = tokenDoc.data().token_device;
                messages.push({
                  notification: { title: "Đến hẹn lại lên", body: event.Ten },
                  token: token
                });
           });
      });
    // Gửi thông báo theo batch (tối đa 500 token mỗi lần)
    const chunks = [];
    while (messages.length) {
      chunks.push(messages.splice(0, 500));
    }

    for (const chunk of chunks) {
      await admin.messaging().sendAll(chunk);
    }
    return null;


  });

exports.helloWorldTest = functions.https.onRequest(async (request, response) => {
   const month = moment(new Date()).tz("Asia/Ho_Chi_Minh").format("M");
   const day = moment(new Date()).tz("Asia/Ho_Chi_Minh").format("D");
    const eventsRef = admin.firestore().collection('events');
    const fcmTokensRef = admin.firestore().collection('fcmtokens');
     var eventsSnapshot = await eventsRef.where('Thang', '==',month);
          eventsSnapshot = await eventsRef.where('Ngay', '==',"28").get();
    const fcmTokens = await fcmTokensRef.get();
    const event = [];
    eventsSnapshot.forEach(doc => {
        event.push(doc.data())
    });

    const token =[];
    fcmTokens.forEach(tokenDoc => {
        token.push(tokenDoc.data());
    });
 response.send({"fcmTokensRef":token,"eventsSnapshot":event});
});
