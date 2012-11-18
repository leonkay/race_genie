
class User
  def initialize(age, name, pic_url)
    # Instance variables
    @age = age
    @name = name
    @pic_url = pic_url
  end

  def self.json_create(object)
    new(object['a'])
  end

  def to_json(*args)
    {
        'age'  => @age,
        'name'    => @name,
        'avatar'  => @pic_url
    }.to_json(*args)
  end

end