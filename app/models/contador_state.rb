class ContadorState
    include Mongoid::Document
    field :position, type: Integer, default: 2
end