class Ability
  include CanCan::Ability

  def initialize(user)
    can :names_for_ids, User if user
    user ||= User.new
    case user.role
    when 'super_admin'
      can :manage, Organization
      can :manage, User
    when 'cso_admin'
      can :manage, User, :organization_id => user.organization_id
      can :read, Organization, :id => user.organization_id
    when nil
      can :create, Organization
    else
      can :read, User, :organization_id => user.organization_id
      can :read, Organization
    end
    can :me, User, :id => user.id
  end
end
