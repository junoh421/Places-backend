class Friendship < ApplicationRecord
  attr_accessor :remember_token
  belongs_to :user, :foreign_key => :friend_id

  after_create do |p|
    if !Friendship.find(:first, :conditions => { :friend_id => p.user_id })
      Friendship.create!(:person_id => p.friend_id, :friend_id => p.user_id)
    end
  end
  after_update do |p|
    reciprocal = Friendship.find(:first, :conditions => { :friend_id => p.user_id })
    reciprocal.is_pending = self.is_pending unless reciprocal.nil?
  end
  after_destroy do |p|
    reciprocal = Friendship.find(:first, :conditions => { :friend_id => p.user_id })
    reciprocal.destroy unless reciprocal.nil?
  end
end

