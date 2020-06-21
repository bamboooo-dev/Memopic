class PseudoSession
  @@statusHash = {}

  def self.getStatus(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]
    end
  end

  def self.putStatus(user_id, context, album_id)
    @@statusHash.store(user_id, {"context"=>context, "album_id"=>album_id, "picture_count"=>0})
  end

  def self.deleteStatus(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash.delete(user_id)
    end
  end

  def self.readContext(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["context"]
    end
  end

  def self.updateContext(user_id, context)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["context"] = context
    end
  end

  def self.readAlbumID(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["album_id"]
    end
  end

  def self.updateAlbumID(user_id, album_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["album_id"] = album_id
    end
  end

  def self.readPictureCount(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["picture_count"]
    end
  end

  def self.incrementPictureCount(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["picture_count"] += 1
    end
  end

  def self.decrementPictureCount(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["picture_count"] -= 1
    end
  end
end
