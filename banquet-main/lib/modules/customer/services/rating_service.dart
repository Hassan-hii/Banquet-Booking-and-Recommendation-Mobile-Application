import 'package:banquet/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RatingService {


  Future<bool> giveReview(double rating, String banquetId) async{
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref('$banquets/$banquetId/ratings');
      await ref.set({
        FirebaseAuth.instance.currentUser?.uid: rating
      });
      return true;
    } catch (e){
      rethrow;
    }
  }
}