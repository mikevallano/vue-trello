
unless List.any?
  ['Backlog', 'In Progress', 'Review', 'Done'].each do |list_name|
    new_list = List.create(name: list_name)
    puts "new list created: #{new_list.name}"
  end
end

unless Card.any?
  List.all.each do |list|
    rand(2..6).times do
      new_card = Card.create(name: FFaker::HipsterIpsum.phrase, list: list)
      puts "new card created: #{new_card.name}, list_id; #{new_card.list.id}"
    end
  end
end
