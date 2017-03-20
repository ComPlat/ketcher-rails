class AtomAbbreviationSerializer < ActiveModel::Serializer
  root false

  attributes :molfile, :name, :rtl_name, :aid, :bid

  def bid
    1
  end
end
