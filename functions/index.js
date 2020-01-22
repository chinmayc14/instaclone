const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onFollowUser = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());

    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const followedUserPostRef = admin
      .firestore()
      .collection("posts")
      .doc(userId)
      .collection("userspost");
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed");

    const followedUserPostSnapshot = await followedUserPostRef.get();
    followedUserPostSnapshot.forEach(doc => {
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
    });
  });

exports.onUnfollowUSer = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed")
      .where("authorId", "==", userId);
    const followedUserPostSnapshot = await userFeedRef.get();
    followedUserPostSnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onUploadPosts = functions.firestore
  .document("/posts/{userId}/userposts/{postId}")
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const postId = contextt.params.postId;
    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(userId)
      .collection("userFollowers");
    const userFollowersSnaphot = await userFollowersRef.get();
    userFollowersSnaphot.forEach(doc => {
      admin
        .firestore()
        .collection("feeds")
        .doc(doc.Id)
        .collection("userFeed")
        .doc(postId)
        .set(snapshot.data());
    });
  });
