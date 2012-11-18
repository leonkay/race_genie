
class User

  attr_accessor :name, :age, :avatar, :email, :gender
  
  def initialize(age, name, pic_url, email, gender)
    # Instance variables
    @age = age
    @name = name
    @avatar = pic_url
    @email = email
    @gender = gender
  end
=begin
  def self.json_create(object)
    new(object['a'])
  end

  def to_json(*args)
    {
        'age'  => @age,
        'name'    => @name,
        'avatar'  => @pic_url,
        'email' => @email,
        'gender' => @gender
    }.to_json(*args)
  end
=end
end