class PseudoSession
  @@statusHash = {}

  def self.getStatus(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]
    end
  end

  def self.putStatus(sender_id, context, album_id)
    @@statusHash.store(sender_id, {"context"=>context, "album_id"=>album_id, "picture_count"=>0})
  end

  def self.deleteStatus(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash.delete(sender_id)
    end
  end

  def self.readContext(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["context"]
    end
  end

  def self.updateContext(sender_id, context)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["context"] = context
    end
  end

  def self.readAlbumID(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["album_id"]
    end
  end

  def self.updateAlbumID(sender_id, album_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["album_id"] = album_id
    end
  end

  def self.readPictureCount(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["picture_count"]
    end
  end

  def self.incrementPictureCount(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["picture_count"] += 1
    end
  end

  def self.decrementPictureCount(sender_id)
    if @@statusHash.has_key?(sender_id)
      @@statusHash[sender_id]["picture_count"] -= 1
    end
  end
end
