# Source : weblog.jamisbuck.org/2015/11/14/little-things-refactoring-with-hashes.html

def first_version
  case params[:student_level]
  when :freshman, :sophomore then
    student = Student::Underclassman.new(name, birthdate,
      address, phone)
  when :junior, :senior then
    student = Student::Upperclassman.new(name, birthdate,
      address, phone)
  when :graduate
    student = Student::Graduate.new(name, birthdate,
      address, phone)
  else
    student = Student::Unregistered.new(name, birthdate,
      address, phone)
  end
end

# case statement was merely selecting a different class
# based on the value of the user input
def second_version
  klass = case params[:student_level]
    when :freshman, :sophomore then
      Student::Underclassman
    when :junior, :senior then
      Student::Upperclassman
    when :graduate
      Student::Graduate
    else
      Student::Unregistered
    end
  student = klass.new(name, birthdate, address, phone)
end

# a hash, except a mapping
# that selects between different values, given some input
def final_version
  # advantage of Hash.new(default_value)
  # to ensure that Student::Unregistered
  # is always what we get for any unrecognized input,
  # and then Hash#merge adds in the specific mappings
  STUDENT_LEVELS = Hash.new(Student::Unregistered).merge(
      freshman:  Student::Underclassman,
      sophomore: Student::Underclassman,
      junior:    Student::Upperclassman,
      senior:    Student::Upperclassman,
      graduate:  Student::Graduate
    )

  # class-selection logic is now separate from the class-instantiation logic

  # to reducing clutter, mapping itself can be declared outside the method

  # That leaves us with just the two lines in the method itself:
  # fetching the class to instantiate, and instantiating it

  klass = STUDENT_LEVELS[params[:student_level]]
  student = klass.new(name, birthdate, address, phone)
end
