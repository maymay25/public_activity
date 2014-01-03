# encoding: utf-8
class User < ActiveRecord::Base

    include Redis::Objects
    
    paginates_per 10

    attr_accessible :nickname, :avatar_path, :username, :picked_at, :status,
                    :email, :encrypted_password, :password, :password_confirmation,
                    :remember_me, :come_from, :come_id,
                    :reset_password_token, :reset_password_sent_at,
                    :remember_created_at, :sign_in_count, :current_sign_in_at,
                    :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip,
                    :is_eraser, :gender
    attr_accessor :password, :password_confirmation

    mount_uploader :avatar_path, AvatarUploader
    attr_accessible :crop_x, :crop_y, :crop_w, :crop_h, :crop_oh, :crop_ow
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :crop_oh, :crop_ow

    has_many :activities_as_owner, :class_name => "Activity", :as => :owner, dependent: :destroy
    has_many :activities_as_recipient, :class_name => "Activity", :as => :recipient

    validates :password, :length=>{:within=>6..20}, :allow_nil => true

    validates :username, :uniqueness => true,:length=>{:within=>2..15},
            :format => { :with => /\A[a-zA-Z][a-zA-Z0-9_]*\z/i }, :allow_nil => true

    validates :email, :uniqueness => true,
            :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i },
            :allow_nil => true

    validates_confirmation_of :password

    COME_FROM = {weibo:1,renren:2,kaixin:3,qq:4,douban:5}
    GENDER = {unknown:0,male:1,female:2}

#rails对象转成二进制字符串
 # Marshal.dump(obj)

#二进制字符串转成rails对象
 # Marshal.load(bin)

    def self.find_come_user(come_id,come_from)
        User.find_by_come_id_and_come_from(come_id.to_s,come_from)
    end


    def self.find_cache(uid)
        uid = uid.to_i
        return nil unless uid>0
        return User.find_by_id(uid) if Settings.redis.online==false
        rkey = "User::id#{uid}"
        resource = User.redis.get(rkey)
        if resource
            begin
                user = Marshal.load(resource)
            rescue
                User.redis.del(rkey)
                return User.find_by_id(uid)
            end
        else
            user = User.find_by_id(uid)
            return nil if user.nil?
            User.redis.set(rkey,Marshal.dump(user))
            User.redis.expire(rkey,Settings.redis.expire);
        end
        return user
    end

    def self.authenticate(account,password)
        return nil if account.nil? or password.nil?
        encrypted_password = encrypt(password)
        
        if account == account.match(/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/).to_s
            user = User.where(email:account,encrypted_password:encrypted_password).first
        else
            user = User.where(username:account,encrypted_password:encrypted_password).first
        end
        return user
    end

    def self.send_signup_mail(user_id)
        user = self.find_by_id(user_id)
        begin
          UserMailer.sign_up(user).deliver
        rescue Exception => e
          Logger.new("#{Rails.root}/log/mail.error.log").info(e)
        end
    end

    def self.signup_error(u)
        return '请填写用户名' if u[:username].nil? or u[:username]==""
        return '请填写昵称' if u[:nickname].nil? or u[:nickname]==""
        return '用户名填写有误。只接受字母，数字或者下划线，且必须以字母打头' if u[:username]!=u[:username].match(/^[a-zA-Z][a-zA-Z0-9_]*$/).to_s
        return '用户名太短，最少3位' if u[:username].length < 3
        return '用户名太长,最多15位' if u[:username].length > 15
        return '请填写邮箱' if u[:email].nil? or u[:email]==""
        return '请填写正确的邮箱地址' if u[:email]!=u[:email].match(/\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/).to_s
        return '请填写密码' if u[:password].nil? or u[:password]==""
        return '为了你的帐号安全，密码长度至少为6位' if u[:password].length<6
        return '密码填写有误。密码长度有限制,最长为20位' if u[:password].length>20
        return '请确认密码' if u[:password_confirmation].nil? or u[:password_confirmation]==""
        return '密码确认有误。两次填写的密码不一致' if u[:password]!=u[:password_confirmation]
        return '该用户名已经被人使用' if User.where(username:u[:username]).count > 0
        return '该邮箱已经被人使用' if User.where(email:u[:email]).count > 0

        return nil
    end

    def update_cache
        if Settings.redis.online
            rkey = "User::id#{self.id}"
            User.redis.set(rkey,Marshal.dump(self))
            User.redis.expire(rkey,Settings.redis.expire)
        end
    end

    def destroy_cache
        if Settings.redis.online
            rkey = "User::id#{self.id}"
            User.redis.del(rkey)
        end
    end
    
    before_save do |r|
        if r.new_record?
            r.encrypted_password = Digest::SHA2.hexdigest(r.password) if r.password 
        end
    end

    after_save do |r|
        r.update_cache
    end


    before_destroy do |r|

    end

    after_destroy do |r|
        r.destroy_cache
    end

end
