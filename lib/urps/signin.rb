module URPS
  class SignIn
    def self.run(data)
      if data['username'].empty? || data['password'].empty?
        return {success?: false, error:"Blank fields"}
      end

      user = RPS.dbi.get_user_by_username(data['username'])
      return {success?: false, error: "No such user"} if user.nil?

      if !user.valid_password?(data['password'])
        return {success?: false, error: "Password Invalid."}
      end

      {
        success?: true,
        session_id: user.username
      }
    end
  end
end