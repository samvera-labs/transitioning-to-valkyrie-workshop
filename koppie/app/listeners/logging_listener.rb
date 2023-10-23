class LoggingListener
  def on_object_deposited(event)
    Hyrax.logger.info("object.deposited: #{event[:object].id}")
  end

  def on_object_metadata_updated(event)
    Hyrax.logger.info("object.metadata.updated: #{event[:object].id}")
  end
end
