class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can [:vote_count_up, :vote_count_down], [Question, Answer] do |votable|
      !user.author?(votable) && (!votable.already_voted?(user, 1) || !votable.already_voted?(user, -1))
    end

    can :best, Answer, question: { user_id: user.id }
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, Attachment do |attachment|
      user.author?(attachment.attachmentable)
    end
    can :destroy, Subscription, user_id: user.id
  end
end


