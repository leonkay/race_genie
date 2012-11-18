
class User

  attr_accessor :name, :age, :pic_url, :email, :gender
  
  def initialize(age, name, pic_url, email, gender)
    # Instance variables
    @age = age
    @name = name
    @pic_url = pic_url
    @email = email
    @gender = gender
  end

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

end