namespace :steal do 
  task :steal => :environment do
    done_8 = ['direct-and-inverse-proportions', 'factorisation','introduction-to-graphs','exponents-and-powers','rational-number', 'linear-equations-in-one-variable', 'understanding-polygons','data-handling', 'squares-and-square-roots', 'cubes-and-cube-roots', 'playing-with-numbers', 'comparing-quantities','algebraic-expressions-and-identities', 'visualizing-solid-shapes']
    done_9 = ['number-systems', 'polynomials','coordinate-geometry','linear-equations-in-two-variables','introduction-to-euclids-geometry', 'lines-and-angles', 'triangles','quadrilaterals',
    'areas-of-parallelograms-and-triangles', 'circles', 'probability','statistics', 'herons-formula', 'surface-areas-and-volumes']

    done_10 = ['triangles', 'probability', 'statistics', 'pair-of-linear-equations-in-two-variables', 'polynomials', 'real-numbers', 'quadratic-equations', 'arithmetic-progression',
      'coordinate-geometry','introduction-to-trigonometry', 'some-applications-of-trigonometry', 'circles']

    chapters = [ 'surface-areas-and-volumes']

    chapters = ['force-and-pressure',
'friction',
'sound',
'some-natural-phenomena',
'light',
'stars-and-the-solar-system']

    # chapters = []

    cookie = "km_ai=7rngi0F6cn5SyVLY8ktfjFYHPGg%3D; km_lv=x; intercom-id-sh7i09tg=c28e212d-69a0-4a35-9795-5104cd5b5b37; admin_sessionid=9b3cb0be6ce7bed9fc5918d1fe5f1ad1; ajs_anonymous_id=%22adb5564d-995f-435c-a9d6-e88bcfe5c8b6%22; ajs_group_id=null; ajs_user_id=%221608938%22; _ga=GA1.2.305201149.1485966755; kvcd=1486020147304; km_vs=1; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20170203%3A3%7CJGDAMDUE4BESXMWLB6LVSD%3A20170203%3A3%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20170203%3A3; csrftoken=EJpjbHVANVlv7KHXWVfJaYi1ecVwxo2M; _gat=1; AWSALB=ACfc+GFGMDt3fvc2Wk6KhFaItANiVWmag30NAisFppOl6XoZgO2tfpAYZ6LUgupwtEF10fvPMdl5ovrZ+JKAB24z/LVkwBmiv85mxJXadDcpbWCCaO9+4JKAXG++"


    chapters.each do |chap_name|  
      if not chapter = Chapter.where(:name => chap_name, :standard_id => standard_id, :subject_id => subject_id).first
        chapter = Chapter.create(:name => chap_name, :subject_id => subject_id, :standard_id => standard_id)
      end

      puts chapter.id

      create_topics chapter

      chapter.topics.each do |topic|
        # next if topic.goal_tid < 8336
        ['medium', 'easy','hard'].each do |difficulty|
          number_of_pages = get_number_of_pages(chap_name, difficulty, topic)
          puts number_of_pages.to_s + "=================================="
          (1..number_of_pages).each do |page|
            begin
              url = get_url(chap_name, page, difficulty, topic)
              puts "========================================== #{url} =============================================="
              data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)
              save_data(data, chapter, difficulty, topic)
              x = Random.rand(40)
              puts x
              sleep(x)
            rescue Exception => e  
              puts e.message + "error error error error error error error error error error error error"
            end
          end
        end
      end
    end
  end
end

def create_topics(chapter)
  cookie = "km_ai=7rngi0F6cn5SyVLY8ktfjFYHPGg%3D; km_lv=x; intercom-id-sh7i09tg=c28e212d-69a0-4a35-9795-5104cd5b5b37; admin_sessionid=9b3cb0be6ce7bed9fc5918d1fe5f1ad1; ajs_anonymous_id=%22adb5564d-995f-435c-a9d6-e88bcfe5c8b6%22; ajs_group_id=null; ajs_user_id=%221608938%22; _ga=GA1.2.305201149.1485966755; kvcd=1486020147304; km_vs=1; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20170203%3A3%7CJGDAMDUE4BESXMWLB6LVSD%3A20170203%3A3%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20170203%3A3; csrftoken=EJpjbHVANVlv7KHXWVfJaYi1ecVwxo2M; _gat=1; AWSALB=ACfc+GFGMDt3fvc2Wk6KhFaItANiVWmag30NAisFppOl6XoZgO2tfpAYZ6LUgupwtEF10fvPMdl5ovrZ+JKAB24z/LVkwBmiv85mxJXadDcpbWCCaO9+4JKAXG++"
  url = "https://www.toppr.com/api/v4/class-8/physics/#{chapter.name}/question-bank/?format=json"
  data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)
  puts data["goals"]
  data["goals"].each do |goal|
    Topic.create(
      :name => goal['goal'],
      :description => goal['goal_description'],
      :topic_number => goal['goal_no'],
      :goal_tid => goal['goal_pk'],
      :standard_id => standard_id,
      :subject_id => subject_id,
      :chapter => chapter
    ) if chapter.topics.where(:name => goal['goal']).count == 0
  end
end

def get_number_of_pages(chap_name, difficulty, topic)
  cookie = "km_ai=7rngi0F6cn5SyVLY8ktfjFYHPGg%3D; km_lv=x; intercom-id-sh7i09tg=c28e212d-69a0-4a35-9795-5104cd5b5b37; admin_sessionid=9b3cb0be6ce7bed9fc5918d1fe5f1ad1; ajs_anonymous_id=%22adb5564d-995f-435c-a9d6-e88bcfe5c8b6%22; ajs_group_id=null; ajs_user_id=%221608938%22; _ga=GA1.2.305201149.1485966755; kvcd=1486020147304; km_vs=1; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20170203%3A3%7CJGDAMDUE4BESXMWLB6LVSD%3A20170203%3A3%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20170203%3A3; csrftoken=EJpjbHVANVlv7KHXWVfJaYi1ecVwxo2M; _gat=1; AWSALB=ACfc+GFGMDt3fvc2Wk6KhFaItANiVWmag30NAisFppOl6XoZgO2tfpAYZ6LUgupwtEF10fvPMdl5ovrZ+JKAB24z/LVkwBmiv85mxJXadDcpbWCCaO9+4JKAXG++"
  url = "https://www.toppr.com/api/v4/class-8/physics/#{chap_name}/question-bank/?format=json'&'page=1'&'difficulty=#{difficulty}'&'goal=#{topic.goal_tid}"
  begin
    data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)
  rescue Exception => e  
    puts "Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error Error "
    return get_number_of_pages(chap_name, difficulty, topic)
  end
  puts "=============== #{data['n_questions']}"
  return data["n_questions"]/10 + 1
end


def get_url chap_name, page, difficulty, topic
  "https://www.toppr.com/api/v4/class-8/physics/#{chap_name}/question-bank/?format=json'&'page=#{page}'&'difficulty=#{difficulty}'&'goal=#{topic.goal_tid}"
end

def save_data(data, chapter, difficulty, topic)
  return if data["questions"].length == 0
  data["questions"].each do |q|
    
    q_created = ShortChoiceQuestion.create(
      :question_text        => q["question"],
      :passage_image        => q["passage_image"],
      :question_image       => q["question_image"],
      :hint_available       => q["hint_available"],
      :passage_footer       => q["passage_footer"],
      :linked_question_tid  => q["question_linked_to_id"],
      :sequence_no          => q["sequence_no"],
      :assertion            => q["assertion"],
      :hint                 => q["hint"],
      :passage              => q["passage"],
      :solution_rating      => q["solution_rating"],
      :correct_answer_id    => "",
      :passage_header       => q["passage_header"],
      :answer_image         => q["solution_image"],
      :reason               => q["reason"],
      :hint_image           => q["hint_image"],
      :multiple_correct     => q["multiple_correct"],
      :question_style       => q["question_style"],
      :level                => q["level"],
      :answer_available     => q["solution_available"],
      :answer               => q["solution"],
      :question_linked      => q["question_linked"],
      :question_tid         => q["question_id"],
      :chapter_id           => chapter.id,
      :standard_id          => standard_id,
      :subject_id           => subject_id,
      :difficulty           => difficulty,
      :topic_id             => topic.id
    )

    q["choices"].each do |a|
      ShortChoiceAnswer.create(
        :correct => a["is_right"],
        :label   => a["label"],
        :image   => a["image"],
        :answer_text => a["choice"],
        :short_choice_question_id => q_created.id
      )
    end

  end
end

def subject_id
  6
end
def standard_id
  1
end