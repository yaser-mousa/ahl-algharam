abstract class LoveStates {}

class InitialLifeState extends LoveStates {}

class FirstlMainState extends LoveStates {}

class ChangeIsPlayState extends LoveStates {}

class ChangeIsLoadingState extends LoveStates {}

class ChangeFirstTime extends LoveStates {}

class SetDurationEvent extends LoveStates {}

class SetPositionEvent extends LoveStates {}

class SetAudioPause extends LoveStates {}

class RefreshAudioPlayer extends LoveStates {}

class ChangeCurrentAd extends LoveStates {}

class ChangeInterstitialAdLoadedTrue extends LoveStates {}

class ChangeInterstitialAdLoadedFalse extends LoveStates {}

class GetDataVoicesSuccess extends LoveStates {}



class GetYaserStoriesDataSuccess extends LoveStates {}

class SetIndex extends LoveStates {}

class PlusLoginShow extends LoveStates {}

class GetArticleSuccess extends LoveStates {}




class TextArticleController extends LoveStates {}

class SignInWithEmailAndPasswordSuccess extends LoveStates {}

class ErrorSignInWithEmailAndPassword extends LoveStates {}



class ChangeWidgetIndex extends LoveStates {}



class ChangeTokenState extends LoveStates {}

class SetTokenNotFirst extends LoveStates {}

class CreateNewStorySuccess extends LoveStates {}

class CreateNewStoryError extends LoveStates {}


class GetFavoriteListSuccess extends LoveStates {}

class GetFavoriteListError extends LoveStates {}



class SetFavoriteListError extends LoveStates {}


class RemoveFavoriteListSuccess extends LoveStates {}

class RemoveFavoriteListError extends LoveStates {}

class SetCountryCode extends LoveStates {}

class SetSaraFont extends LoveStates {}

class SetSaraBool extends LoveStates {}

class SetPhoneNumber extends LoveStates {}

class CodeNotCorrect extends LoveStates {
  String? error;
  CodeNotCorrect(this.error);
}

class ProfileImagePickedSuccessState extends LoveStates {}

class ProfileImagePickedErrorState extends LoveStates {}

class UploadProfileImageLoadingState extends LoveStates {}

class UploadProfileImageSuccessState extends LoveStates {
  String? profileImageUrl;
  UploadProfileImageSuccessState(this.profileImageUrl);

}


class UploadProfileImageErrorState extends LoveStates {}


class CreateUserSuccessDataState extends LoveStates {
  String? uid;

  CreateUserSuccessDataState(this.uid);

}

class CreateUserErrorDataState extends LoveStates {
  String eroorr;
  CreateUserErrorDataState(this.eroorr);

}

class SetTextSize extends LoveStates {}

class ChangeAdminState extends LoveStates {}

class CreateLikeFirstStepSuccess extends LoveStates {}

class CreateLikeLastStepSuccess extends LoveStates {}

class RemoveLikeFromListFirstStep extends LoveStates {}

class RemoveLikeFromListLastStep extends LoveStates {}

class CreateLikeError extends LoveStates {}

class ThisUserDataSuccess extends LoveStates {}

class ThisUserDataError extends LoveStates {}

class GetUserDataSuccess extends LoveStates {}

class GetUserDataError extends LoveStates {}



class BlockUserFromIdSuccess extends LoveStates {}

class BlockUserFromIdError extends LoveStates {}

class UnblockUserFromIdSuccess extends LoveStates {}

class UnblockUserFromIdError extends LoveStates {}

class GetLikesUidSuccess extends LoveStates {}

class GetLikesUidError extends LoveStates {}

class UpdateLikeForStory extends LoveStates {}

class LoadingGetStoriesUsers extends LoveStates {}



class GetLimitUsersStoriesDataError extends LoveStates {}



class CheckBoxChangeState extends LoveStates {}