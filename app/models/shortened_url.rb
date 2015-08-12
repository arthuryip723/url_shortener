class ShortenedUrl < ActiveRecord::Base
  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )
  def self.random_code
    code = SecureRandom.urlsafe_base64
    until !exists?(:short_url => code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    code  = ShortenedUrl.random_code
    ShortenedUrl.create!(:short_url => code, :submitter_id => user.id, :long_url => long_url)
  end
end
