class ShortenedUrl < ActiveRecord::Base
  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  # has_many(
  #   :visitors,
  #   class_name: "User",
  #   through: :visits,
  #   source: :visitor
  # )

  has_many(
    :visitors,
    Proc.new { distinct }, #<<<
    through: :visits,
    source: :visitor
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

  def num_clicks
    Visit.where(shortened_url_id: id).count
  end

  def num_uniques
    Visit.select(:user_id).distinct.where(shortened_url_id: id).count
  end

  def num_recent_uniques
    Visit.select(:user_id).distinct.where(shortened_url_id: id).where('created_at > ?', 10.minutes.ago).count
  end
end
