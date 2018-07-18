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
      !user.author?(votable)
    end

    can :best, Answer, question: { user_id: user.id }
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
  end
end

# See the wiki for details:
# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
