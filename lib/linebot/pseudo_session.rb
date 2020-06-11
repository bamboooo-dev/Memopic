class PseudoSession
  @@statusHash = {}

  def self.getStatus(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]
    end
  end

  def self.putStatus(user_id, context, album_name)
    @@statusHash.store(user_id, {"context"=>context, "album_name"=>album_name})
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

  def self.readAlbumName(user_id)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["album_name"]
    end
  end

  def self.updateContext(user_id, context)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["context"] = context
    end
  end

  def self.updateAlbumName(user_id, album_name)
    if @@statusHash.has_key?(user_id)
      @@statusHash[user_id]["album_name"] = album_name
    end
  end
end
