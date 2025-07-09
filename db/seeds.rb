# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"

states_and_lgas = {
  "Abia" => ["Aba North", "Aba South", "Arochukwu", "Bende", "Ikwuano", "Isiala Ngwa North", "Isiala Ngwa South", "Isuikwuato", "Obi Ngwa", "Ohafia", "Osisioma", "Ugwunagbo", "Ukwa East", "Ukwa West", "Umuahia North", "Umuahia South"],
  "Adamawa" => ["Demsa", "Jada", "Lamurde", "Madagali", "Maiha", "Mayo Belwa", "Michika", "Mubi North", "Mubi South", "Numan", "Shelleng", "Song", "Toungo"],
  "Akwa Ibom" => ["Eastern Obolo", "Eket", "Essien Udim", "Ibeno", "Ibesikpo Asutan", "Ibiono Ibom", "Ika", "Ikono", "Itu", "Mbo", "Nsit Atai", "Nsit Ibom", "Nsit Ubium", "Obot Akara", "Okobo", "Onna", "Oron", "Oruk Anam", "Udung Uko", "Ukanafun", "Uruan", "Uyo"],
  "Anambra" => ["Aguata", "Anambra East", "Anambra West", "Anaocha", "Awka North", "Awka South", "Ayamelum", "Dunukofia", "Ekwusigo", "Idemili North", "Idemili South", "Ihiala", "Njikoka", "Nnewi North", "Nnewi South", "Ogbaru", "Onitsha North", "Onitsha South", "Orumba North", "Orumba South", "Oyi"],
  "Bauchi" => ["Alkaleri", "Bauchi", "Bogoro", "Damban", "Darazo", "Dass", "Gamawa", "Ganjuwa", "Giade", "Itas Gadau", "Jama'are", "Katagum", "Kirfi", "Misau", "Ningi", "Shira", "Tafawa Balewa", "Warji", "Zaki"],
  "Bayelsa" => ["Brass", "Ekeremor", "Kolokuma/Opokuma", "Nembe", "Ogbia", "Sagbama", "Southern Ijaw", "Yenagoa"],
  "Benue" => ["Apa", "Buruku", "Gboko", "Guma", "Gwer East", "Gwer West", "Katsina-Ala", "Konshisha", "Kwande", "Logo", "Makurdi", "Obi", "Ogbadibo", "Ohimini", "Oju", "Okpokwu", "Oturkpo", "Tarka", "Ukum", "Ushongo", "Vandeikya"],
  "Borno" => ["Abadam", "Askira/Uba", "Bama", "Bayo", "Biu", "Chibok", "Damboa", "Dikwa", "Gubio", "Guzamala", "Gwoza", "Hawul", "Jere", "Kaga", "Kala/Balge", "Konduga", "Kukawa", "Kwaya Kusar", "Mafa", "Magumeri", "Maiduguri", "Marte", "Mobbar", "Monguno", "Ngala", "Nganzai", "Shani"],
  "Cross River" => ["Akamkpa", "Biase", "Boki", "Calabar Municipal", "Calabar South", "Etung", "Ikom", "Obanliku", "Obubra", "Obudu", "Odukpani", "Ogoja", "Yakuur", "Yala"],
  "Delta" => ["Aniocha North", "Aniocha South", "Bomadi", "Burutu", "Ethiope East", "Ethiope West", "Ika North East", "Ika South", "Isoko North", "Isoko South", "Ndokwa East", "Ndokwa West", "Okpe", "Oshimili North", "Oshimili South", "Patani", "Sapele", "Udu", "Ughelli North", "Ughelli South", "Ukwuani", "Uvwie", "Warri North", "Warri South", "Warri South West"],
  "Ebonyi" => ["Afikpo North", "Afikpo South", "Ebonyi", "Ezza North", "Ezza South", "Ikwo", "Ishielu", "Ohaukwu", "Onicha", "Ovo", "Abakaliki", "Izzi", "Ohaukwu", "Ishielu", "Ivo", "Ikwo"],
  "Edo" => ["Akoko-Edo", "Egor", "Esan Central", "Esan North-East", "Esan South-East", "Esan West", "Etsako Central", "Etsako East", "Etsako West", "Igueben", "Ikpoba Okha", "Orhionmwon", "Ovia North-East", "Ovia South-West", "Owan East", "Owan West", "Uhunmwonde"],
  "Ekiti" => ["Ado Ekiti", "Efon", "Ekiti East", "Ekiti South-West", "Ekiti West", "Emure", "Gbonyin", "Ido Osi", "Ijero", "Ikere", "Ikole", "Ilejemeje", "Irepodun/Ifelodun", "Ise/Orun", "Moba", "Oye"],
  "Gombe" => ["Funakaye", "Gombe", "Kwami", "Nafada", "Shomgom", "Yamaltu/Deba", "Zaki"],
  "Enugu" => ["Aninri", "Awgu", "Enugu East", "Enugu North", "Enugu South", "Ezeagu", "Igbo Etiti", "Igbo Eze North", "Igbo Eze South", "Isi Uzo", "Nkanu East", "Nkanu West", "Nsukka", "Oji River", "Udenu", "Udi", "Uzo Uwani"],
  "FCT" => ["Abaji", "Bwari", "Gwagwalada", "Kuje", "Kwali", "Municipal Area Council"],
  "Imo" => ["Aboh Mbaise", "Ahiazu Mbaise", "Ehime Mbano", "Ezinihitte", "Ideato North", "Ideato South", "Ihitte/Uboma", "Ikeduru", "Isiala Mbano", "Isu", "Mbaitoli", "Mbaitoli North", "Mbaitoli South", "Ngor Okpala", "Njaba", "Nkwerre", "Nwangele", "Obowo", "Oguta", "Ohaji Egbema", "Okigwe", "Orlu", "Orsu", "Oru East", "Oru West", "Owerri Municipal", "Owerri North", "Owerri West"],
  "Jigawa" => ["Auyo", "Babura", "Birnin Kudu", "Buji", "Dutse", "Gagarawa", "Garki", "Gumel", "Guri", "Gwaram", "Gwiwa", "Hadejia", "Kafin Hausa", "Kaugama Kazaure", "Kiri Kasama", "Kiyawa", "Maigatari", "Malam Madori", "Miga", "Nasarawa", "Roni", "Sule Tankarkar", "Taura", "Yankwashi"],
  "Kaduna" => ["Birnin Gwari", "Chikun", "Giwa", "Igabi", "Ikara", "Jaba", "Jema'a", "Kachia", "Kaduna North", "Kaduna South", "Kagarko", "Kajuru", "Kaura", "Kauru", "Kubau", "Kunchi", "Lere", "Makarfi", "Sabon Gari", "Sanga", "Soba", "Zangon Kataf", "Zaria"],
  "Kano" => ["Ajingi", "Albasu", "Bagwai", "Bakori", "Bebeji", "Bichi", "Bunkure", "Dala", "Dambatta", "Dawakin Kudu", "Dawakin Tofa", "Doguwa", "Fagge", "Gabasawa", "Garko", "Garun Mallam", "Gaya", "Gezawa", "Gwale", "Gwarzo", "Kabo", "Kano Municipal", "Karaye", "Kibiya", "Kiru", "Kumbotso", "Kunchi", "Lafiaji", "Lere", "Makoda", "Nassarawa", "Rano", "Rimin Gado", "Rogo", "Shanono", "Sumaila", "Takai", "Tarauni", "Tofa", "Tsanyawa", "Tudun Wada", "Wudil"],
  "Katsina" => ["Bakori", "Batagarawa", "Batsari", "Baure", "Bindawa", "Charanchi", "Danmusa", "Dandume", "Danja", "Dan Musa", "Daura", "Dutsi", "Dutsin Ma", "Faskari", "Funtua", "Ingawa", "Jibia", "Kafur", "Kaita", "Kankara", "Kankia", "Katsina", "Kurfi", "Kusada", "Mai'Adua", "Malumfashi", "Mani", "Matsatsantsa", "Mayo Belwa", "Nangere", "Rimi", "Sabon Birni", "Shani", "Takai", "Tassa", "Yankwashi"],
  "Kebbi" => ["Aleiro", "Arewa Dandi", "Argungu", "Augie", "Bagudo", "Birnin Kebbi", "Bunza", "Dandi", "Fakai", "Gaya", "Gwadabawa", "Gwaski", "Kalgo", "Koko/Besse", "Mai'Adua", "Ngaski", "Sakaba", "Shanga", "Suru", "Wasagu/Kankia", "Yauri", "Zuru"],
  "Kogi" => ["Adavi", "Ajaokuta", "Ankpa", "Bassa", "Dekina", "Ibaji", "Idah", "Igalamela Odolu", "Ijumu", "Kabba/Bunu", "Kogi", "Lokoja", "Mopa Muro", "Ofu", "Ogori Magongo", "Okehi", "Olamaboro", "Omala", "Oyi", "Yagba East", "Yagba West"],
  "Kwara" => ["Asa", "Baruten", "Edu", "Ekiti", "Ifelodun", "Ilorin East", "Ilorin South", "Ilorin West", "Irepodun", "Isin", "Kaiama", "Moro", "Offa", "Oke Ero", "Oyun", "Pategi"],
  "Lagos" => ["Agege", "Ajeromi-Ifelodun", "Alimosho", "Amuwo Odofin", "Apapa", "Badagry", "Epe", "Eti Osa", "Ibeju Lekki", "Ifako Ijaiye", "Ikeja", "Ikorodu", "Kosofe", "Lagos Island", "Lagos Mainland", "Mushin", "Ojo", "Ojodu", "Oshodi-Isolo", "Shomolu", "Surulere"],
  "Nasarawa" => ["Akwanga", "Awe", "Doma", "Karu", "Keana", "Keffi", "Kokona", "Lafia", "Nasarawa", "Nasarawa Egon", "Toto", "Wamba"],
  "Niger" => ["Agaie", "Agwara", "Bida", "Borgu", "Bosso", "Chanchaga", "Edati", "Gbako", "Gurara", "Katcha", "Kontagora", "Lapai", "Lavun", "Magama", "Mariga", "Mashegu", "Mokwa", "Muya", "Paikoro", "Rijau", "Shiroro", "Suleja", "Tafa", "Wushishi"],
  "Ogun" => ["Abeokuta North", "Abeokuta South", "Adigbe", "Ado-Odo/Ota", "Agbado", "Aje", "Amukoko", "Awe", "Baiyewu", "Ijebu East", "Ijebu North", "Ijebu Ode", "Ikenne", "Imeko Afon", "Ipokia", "Obafemi Owode", "Odeda", "Odogbolu", "Ogun Waterside", "Remo North", "Shagamu", "Shagamu West", "Sobukun", "Yewa North", "Yewa South"],
  "Ondo" => ["Akoko North-East", "Akoko North-West", "Akoko South-West", "Akoko South-East", "Akure North", "Akure South", "Ese Odo", "Idanre", "Ifedore", "Ilaje", "Ile Oluji/Okeigbo", "Irele", "Odigbo", "Okitipupa", "Ondo East", "Ondo West", "Ose", "Owo"],
  "Osun" => ["Atakunmosa", "Atakunmosa East", "Aiyedaade", "Aiyedire", "Boluwaduro", "Boripe", "Ede North", "Ede South", "Ife Central", "Ife East", "Ife North", "Ife South", "Egbedore", "Ejigbo", "Ife East", "Ife North", "Ife South", "Ila", "Ilesha East", "Ilesha West", "Irepodun", "Irewole", "Isokan", "Iwo", "Obokun", "Odo Otin", "Ola Oluwa", "Olorunda", "Oriade", "Osogbo"],
  "Oyo" => ["Afijio", "Akinyele", "Atiba", "Atisbo", "Egbeda", "Ibadan Central", "Ibadan North", "Ibadan North-East", "Ibadan North-West", "Ibadan South-East", "Ibadan South-West", "Ibarapa Central", "Ibarapa East", "Ibarapa North", "Ido", "Irepo", "Iseyin", "Itesiwaju", "Iwajowa", "Kajola", "Lagelu", "Ogbomoso North", "Ogbomoso South", "Ogo Oluwa", "Olorunsogo", "Oluyole", "Ona Ara", "Orelope", "Orire", "Oyo", "Oyo East", "Oyo West", "Paudu", "Saki East", "Saki West", "Surulere"],
  "Plateau" => ["Barikin Ladi", "Bassa", "Bokkos", "Jos East", "Jos North", "Jos South", "Kanam", "Kanke", "Langtang North", "Langtang South", "Mangu", "Mikang", "Pankshin", "Qua'an Pan", "Riyom", "Shendam", "Wase"],
  "Rivers" => ["Abua/Odual", "Ahoada East", "Ahoada West", "Akuku-Toru", "Andoni", "Asari-Toru", "Bonny", "Degema", "Eleme", "Emohua", "Etche", "Gokana", "Ikwerre", "Khana", "Obio/Akpor", "Ogba/Egbema/Ndoni", "Ogu/Bolo", "Okrika", "Omuma", "Opobo/Nkoro", "Oyigbo", "Port Harcourt", "Tai"],
  "Sokoto" => ["Binji", "Bodinga", "Dange Shuni", "Gada", "Goronyo", "Gudu", "Gwadabawa", "Illela", "Kebbe", "Kware", "Rabah", "Sabon Birni", "Shagari", "Silame", "Sokoto North", "Sokoto South", "Tambuwal", "Toro", "Wamako", "Wurno", "Yabo"],
  "Taraba" => ["Ardo Kola", "Bali", "Donga", "Gashaka", "Gassol", "Ibi", "Jalingo", "Karim Lamido", "Kurmi", "Lau", "Sardauna", "Takum", "Ussa", "Wukari", "Yorro", "Zing"],
  "Yobe" => ["Fika", "Fune", "Geidam", "Gujba", "Gulani", "Jakusko", "Karasuwa", "Machina", "Nangere", "Nguru", "Potiskum", "Tarmuwa", "Yusufari", "Zaki"],
  "Zamfara" => ["Anka", "Bakura", "Birnin Magaji/Kiyaw", "Bukkuyum", "Bungudu", "Gummi", "Gusau", "Kaura Namoda", "Maradun", "Maru", "Shinkafi", "Talata Mafara", "Tsafe", "Zurmi"]
}

states_and_lgas.each do |state_name, lgas|
  state = State.find_or_create_by!(name: state_name)
  lgas.each do |lga_name|
    Locality.find_or_create_by!(name: lga_name, state: state)
  end
end

# Features with explicit IDs (matches Supabase table)
features_with_ids = [
  [1, "Swimming Pool"],
  [2, "Garden"],
  [3, "Garage"],
  [4, "Borehole"],
  [5, "Security Fence"],
  [7, "Boy's Quarters"],
  [8, "Fast Internet"],
  [9, "24 Hours Security"],
  [10, "Children's Playground"],
  [11, "Big Compound"],
  [12, "C of O"],
  [13, "Elevator"],
  [14, "Free WiFi"],
  [15, "Church Nearby"],
  [16, "24 Hours Electricity"],
  [17, "CCTV Cameras"]
]

features_with_ids.each do |id, name|
  Feature.upsert({ id: id, name: name, created_at: Time.now, updated_at: Time.now }, unique_by: :id)
end

# Add this line to define 'features' for later use
features = Feature.where(id: features_with_ids.map(&:first)).to_a

# Pick a locality for properties (use the first one for simplicity)
locality = Locality.first
state = locality.state

# Dummy Users and Properties
users_data = [
  {
    first_name: "Jane",
    last_name: "Doe",
    email: "jane@example.com",
    telephone: "08031234567",
    password: "password"
  },
  {
    first_name: "John",
    last_name: "Smith",
    email: "john@example.com",
    telephone: "08039876543",
    password: "password"
  }
]

users_data.each_with_index do |user_data, idx|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.first_name = user_data[:first_name]
    u.last_name = user_data[:last_name]
    u.telephone = user_data[:telephone]
    u.password = user_data[:password]
    u.password_confirmation = user_data[:password]
  end

  property = user.properties.find_or_create_by!(
    title: "#{user.first_name}'s Modern Home",
    street: "123 Example St"
  ) do |p|
    p.purpose = :rent
    p.property_type = :house
    p.price = 150_000 + idx * 50_000
    p.description = "A beautiful modern house with great amenities."
    p.bedrooms = 3 + idx
    p.bathrooms = 2 + idx
    p.instagram_video_link = "https://www.instagram.com/p/xyz#{idx}/"
    p.locality = locality
    p.state_id = state.id
  end

  # Attach an online image if not already attached
  unless property.picture.attached?
    image_url = "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80"
    property.picture.attach(
      io: URI.open(image_url),
      filename: "property#{idx+1}.jpg",
      content_type: "image/jpeg"
    )
  end

  # Add features to property if not already present
  if property.features.empty?
    property.features << features.sample(2)
  end
end

# Add a new user with 3 properties for sale
new_user = User.find_or_create_by!(email: "mary@example.com") do |u|
  u.first_name = "Mary"
  u.last_name = "Johnson"
  u.telephone = "08035551234"
  u.password = "password"
  u.password_confirmation = "password"
end

# Pick 3 different localities and their states
localities = Locality.limit(3).to_a
sale_images = [
  "https://images.unsplash.com/photo-1699435870820-36eab47448f8?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGxhemElMjBmb3IlMjBzYWxlfGVufDB8fDB8fHww",
  "https://images.unsplash.com/photo-1507089947368-19c1da9775ae?auto=format&fit=crop&w=800&q=80",
  "https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=80"
]

3.times do |i|
  locality = localities[i]
  state = locality.state
  property = new_user.properties.find_or_create_by!(
    title: "Mary's Sale Property #{i+1}",
    street: "#{100 + i} Market Road"
  ) do |p|
    p.purpose = :sale
    p.property_type = :house
    p.price = 300_000 + i * 100_000
    p.description = "A premium property for sale in #{locality.name}, #{state.name}."
    p.bedrooms = 4 + i
    p.bathrooms = 3 + i
    p.instagram_video_link = "https://www.instagram.com/p/sale#{i}/"
    p.locality = locality
    p.state_id = state.id
  end
  # Attach a unique online image if not already attached
  unless property.picture.attached?
    property.picture.attach(
      io: URI.open(sale_images[i]),
      filename: "mary_property#{i+1}.jpg",
      content_type: "image/jpeg"
    )
  end
  # Add features to property if not already present
  if property.features.empty?
    property.features << features.sample(2)
  end
end

