require 'rails_helper'

feature "Managing cinefiles" do
  before do
    sign_up
    click_link_cinefile
  end

  context "Adding films" do

    scenario "A user can add a film to their Cinefile " do
      add_film
      expect(page).to have_content 'Brazil'
      expect(page).to have_content 'Brazil has successfully been Cinefiled!'
    end

    scenario "A user cannot add a film which already exists in their Cinefile" do
      add_film
      add_film
      expect(page).to have_content "Brazil has previously been Cinefiled"
    end

    scenario "A user cannot search for 'nothing'" do
      fill_in :search, with: ""
      click_button 'Search'
      expect(page).to have_content("Please enter a film in the search box")
    end

    scenario "Films with commas can be added to cinefiles without causing errors" do
      add_film(title: 'The Good, the Bad and the Ugly')
      expect(page).to have_content "The Good, the Bad and the Ugly"
    end
  end

  context "Viewing the Cinefile" do

    scenario 'The Cinefile displays the current user' do
      expect(page).to have_content "test's Cinefile"
    end

    scenario "Film and release year are displayed for each film in Cinefile" do
      add_film
      expect(page).to have_content 'Brazil'
      expect(page).to have_content '1985'
    end

    scenario "Film images are included with each film in Cinefile" do
      add_film(title: 'Fight Club')
      expect(page).to have_css("//img[@src*='http://cf2.imgobject.com/t/p/w500//8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg']")
    end

    scenario "The cinefile displays the total number of films in the Cinefile" do
      add_film(title: 'Fight Club')
      add_film(title: 'Blade Runner')
      expect(page).to have_content "Cinefiled: 2"
    end

    scenario "The cinefile displays the total number of films with upcoming screenings in Cinefile" do
      film = Film.create(title: 'Brazil', tmdb_id: '68', poster_path: '/pVlZBKp8v3Jzd0ahPmrBGlbeQ2s.jpg')
      Screening.create(film_id: film.id, screen_date: Time.now + 86400, screen_time: "22:00")
      add_film(title: 'Brazil')
      expect(page).to have_content "Upcoming: 1"
    end

    scenario "Users are informed if their Cinefile is empty" do
      expect(page).to have_content "Your Cinefile is empty :("
    end

    scenario "Users can delete films from their cinefile" do
      add_film
      expect(page).to have_content "Brazil"
      within(".remove") do
        click_link ''
      end
      expect(page).to have_content "'Brazil' was successfully removed from your Cinefile"
    end
  end
end
