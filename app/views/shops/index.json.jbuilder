json.status 200
json.shops @publisher_shops do |publisher_shop|
  json.call publisher_shop.shop, :id, :name
  json.call publisher_shop,      :books_sold_count

  json.books publisher_shop.shop.shop_books do |shop_book|
    json.call shop_book.book, :id, :title
    json.call shop_book,      :copies_in_stock
  end
end
