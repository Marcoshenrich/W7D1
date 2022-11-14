class User < ApplicationRecord
    validates :password_digest, presence: true
    validates :session_token, :username, presence: true, uniqueness: true
    validates :password, length: {minimum: 6}, allow_nil:true
    before_validation :ensure_session_token

    attr_reader :password



    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        pass_obj = BCrypt::Password.new(password_digest)
        pass_obj.is_password?(password)
    end

    def reset_session_token
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end 

    private
    def generate_unique_session_token
        token = SecureRandom::urlsafe.base64
        while user.exists?(session_token: token)
            token = SecureRandom::urlsafe.base64
        end
        token
    end

end