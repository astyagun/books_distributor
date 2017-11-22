json.status 200
json.shops @publisher_shops do |publisher_shop|
  json.call publisher_shop.shop, :id, :name
  json.call publisher_shop,      :books_sold_count

  json.books publisher_shop.shop.book_shops do |book_shop|
    json.call book_shop.book, :id, :title
    json.call book_shop,      :copies_in_stock
  end
end
