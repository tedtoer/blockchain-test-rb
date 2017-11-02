class Block
  def initialize(index:, previous_hash:, timestamp:, data:, hash:)
    @index = index
    @previous_hash = previous_hash.to_s
    @timestamp = timestamp.to_i
    @data = data
    @hash = hash.to_s
  end

  attr_reader :index, :previous_hash, :timestamp, :data, :hash
end

class Service
  def self.calculate_hash(index:, previous_hash:, timestamp:, data:)
    Digest::SHA256.hexdigest(index + previous_hash + timestamp + data)
  end

  def self.calculate_hash_for_block(block:)
    self.calculate_hash(
      index: block.index,
      previous_hash: block.previous_hash,
      timestamp: block.timestamp,
      data: block.data
    )
  end

  def self.generate_next_block(data:)
    previous_block = get_latest_block
    next_index = previous_block.index + 1
    next_timestamp = Time.now.to_i / 1000
    next_hash = calculate_hash(
      index: next_index,
      previous_hash: previous_block.hash,
      timestamp: next_timestamp,
      data: data
    )

    Block.new(
      index: next_index,
      previous_hash: previous_block.hash,
      timestamp: next_timestamp,
      data: data,
      hash: next_hash
    )
  end

  def self.get_latest_block
  end

  def self.is_valid_new_block?(new_block:, previous_block:)
    if previous_block.index + 1 != new_block.index
      puts('invalid index')
      false
    elsif previous_block.hash != new_block.previous_hash
      puts('invalid previous_hash')
      false
    elsif calculate_hash_for_block(new_block) != new_block.hash
      puts("invalid hash: #{calculate_hash_for_block(new_block)} #{new_block.hash}")
      false
    else
      true
    end
  end
end

GENESIS_BLOCK = Block.new(
  index: 0,
  previous_hash: '0',
  timestamp: 1465154705,
  data: 'List of Denmark national football team results – 1970s',
  hash: '7a834ad8919f8142a229e1f0298d304fa6abc4f3ad534121a3d68275fd03a762'
).freeze

blockchain = [GENESIS_BLOCK]
