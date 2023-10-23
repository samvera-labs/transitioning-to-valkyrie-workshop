class MintId
  include Dry::Monads[:result]

  def call(obj)
    return Failure[:no_identifier_attribute] unless
      obj.respond_to?(:identifier=)

    return Failure[:object_not_persisted] unless
      obj.try(:persisted?)

    user = User.find_by_user_key(obj.depositor)

    obj.identifier = "my_id_scheme:#{obj.id}"

    result = Hyrax.persister.save(resource: obj)
    Hyrax.publisher.publish("object.metadata.updated", object: obj, user: user)

    Success(result)
  end
end
