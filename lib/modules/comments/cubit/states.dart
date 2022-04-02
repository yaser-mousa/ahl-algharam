abstract class CommentStates{}

class InitialCommentState extends CommentStates{}

class GetAllCommentsSuccess extends CommentStates{}

class GetAllCommentsError extends CommentStates{}

class CreateCommentSuccess extends CommentStates{}

class CreateCommentError extends CommentStates{}



class ChangeNaxLines extends CommentStates{}

class CommentUpdateSuccess extends CommentStates{}

class CommentUpdateError extends CommentStates{}

class CommentDeleteSuccess extends CommentStates{}

class CommentDeleteError extends CommentStates{}

class ChangeIsExpanded extends CommentStates{}



///////////////////////////// replay //////////////////////


class GetAllReplaySuccess extends CommentStates{}

class GetAllReplayError extends CommentStates{}

class CreateReplaySuccess extends CommentStates{}

class CreateReplayError extends CommentStates{}

class ChangeIsReplayState extends CommentStates{}



class ChangeReplaysExpandedState extends CommentStates{}

class ChangeCommentIndex extends CommentStates{}

class ChangeReplayIndex extends CommentStates{}

class DeleteReplayCommentSuccess extends CommentStates{}

class DeleteReplayCommentError extends CommentStates{}



class UpdateReplayCommentSuccess extends CommentStates{}

class UpdateReplayCommentError extends CommentStates{}

class LoadingGetCommentsLimit extends CommentStates{}