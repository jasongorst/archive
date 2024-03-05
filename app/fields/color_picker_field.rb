require "administrate/field/base"

class ColorPickerField < Administrate::Field::Base
  def to_s
    data
  end
end
