def create_places
  @place1 = Place.create(name: 'Pasta Go', address: 'Kościuszki 32', menu_url: 'https://http://pastago.pl/menu/')
  @place2 = Place.create(name: 'Gastromachina', address: 'Piotrkowska 89', menu_url: 'https://www.facebook.com/gastromachina/menu/')
  @place3 = Place.create(name: 'Zahir', address: '6 Sierpnia', menu_url: 'http://zahirkebab.pl/lokale/lodz-ul-6-go-sierpnia-13-centrum/')
  @place4 = Place.create(name: 'Da Grasso', address: 'Zachodnia 105', menu_url: 'https://www.dagrasso.pl/lodz-zachodnia')
end

def reset_database()
  Item.destroy_all
  Order.destroy_all
  User.destroy_all
  Place.destroy_all
end

if Rails.env == 'development'
  reset_database
  create_places
  @user1 = User.create(email: 'one@user.pl', password: '123456')
  @user2 = User.create(email: 'two@two.pl', password: '123456')
  @user3 = User.create(email: 'three@two.pl', password: '123456')
  @order1 = Order.create(creator_id: @user1.id, place_id: @place1.id, deadline: 2.hours.from_now - 50.hours)
  @order2 = Order.create(creator_id: @user2.id, place_id: @place2.id, deadline: 5.hours.from_now, orderer_id: @user2.id)
  @order3 = Order.create(creator_id: @user3.id, place_id: @place3.id, deadline: 3.hours.from_now, orderer_id: @user1.id, deliverer_id: @user2.id)
  Item.create(user_id: @user1.id, order_id: @order3.id, food: 'Smaczne jedzonko.', cost: 12.50)
  Item.create(user_id: @user2.id, order_id: @order1.id, food: 'Słodko kwaśne jedzonko.', cost: 32.78)
  Item.create(user_id: @user3.id, order_id: @order2.id, food: 'Słone jedzonko.', cost: 50.00)
else
  create_places
end
