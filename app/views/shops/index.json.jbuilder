json.shops @publisher_shops do |publisher_shop|
  json.id               publisher_shop.shop_id
  json.name             publisher_shop.shop.name
  json.books_sold_count publisher_shop.books_sold_count

  json.books publisher_shop.shop.book_shops do |book_shop|
    json.id              book_shop.book_id
    json.title           book_shop.book.title
    json.copies_in_stock book_shop.copies_in_stock
  end
end
