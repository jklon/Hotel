namespace :steal do 
  task :steal => :environment do
    done_8 = ['direct-and-inverse-proportions', 'factorisation','introduction-to-graphs','exponents-and-powers','rational-number', 'linear-equations-in-one-variable', 'understanding-polygons','data-handling', 'squares-and-square-roots', 'cubes-and-cube-roots', 'playing-with-numbers', 'comparing-quantities','algebraic-expressions-and-identities', 'visualizing-solid-shapes']
    done_9 = []
    chapters = [ 'polynomials', 'coordinate-geometry', 'linear-equations-in-two-variables', 'introduction-to-euclids-geometry',
      'lines-and-angles','triangles', 'quadrilaterals', 'areas-of-parallelograms-and-triangles', 'circles', 'herons-formula', 
      'surface-areas-and-volumes', 'statistics', 'probability']


    # chapters = ['rational-number']
    # chapters = ['understanding-polygons', 'linear-equations-in-one-variable']
    chapters = ['number-systems'] # To be done
    cookie = "csrftoken=lZKGxtJzec9uIJ3jx0McYWRewnV7Gqo0; _ga=GA1.2.949189307.1476968295; _fp73=ebdd7ad2-8b89-6c94-b899-d369c2ef82b5; ajs_user_id=%221393635%22; ajs_group_id=null; ajs_anonymous_id=%22751ec092-5b52-4c75-aa22-46c4e1ebf419%22; intercom-id-sh7i09tg=054dde12-06c0-4035-a1a4-71e0c6b8315d; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20161019%3A7%7CJGDAMDUE4BESXMWLB6LVSD%3A20161019%3A7%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20161019%3A7; admin_sessionid=eb1e428e6198fd4b568732b78ef9b702"


    chapters.each do |chap_name|
      if not chapter = Chapter.find_by(:name => chap_name)
        chapter = Chapter.create(:name => chap_name, :subject_id => subject_id, :standard_id => standard_id)
      end

      create_topics chapter

      chapter.topics.each do |topic|
        ['medium', 'easy', 'hard'].each do |difficulty|
          number_of_pages = get_number_of_pages(chap_name, difficulty, topic)
          puts number_of_pages.to_s + "=================================="
          (1..number_of_pages).each do |page|
            url = get_url(chap_name, page, difficulty, topic)
            puts "========================================== #{url} =============================================="
            data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)
            save_data(data, chapter, difficulty, topic)
            sleep(Random.rand(100))
          end
        end
      end
    end

  end
end

def create_topics(chapter)
  cookie = "csrftoken=lZKGxtJzec9uIJ3jx0McYWRewnV7Gqo0; _ga=GA1.2.949189307.1476968295; _fp73=ebdd7ad2-8b89-6c94-b899-d369c2ef82b5; ajs_user_id=%221393635%22; ajs_group_id=null; ajs_anonymous_id=%22751ec092-5b52-4c75-aa22-46c4e1ebf419%22; intercom-id-sh7i09tg=054dde12-06c0-4035-a1a4-71e0c6b8315d; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20161019%3A7%7CJGDAMDUE4BESXMWLB6LVSD%3A20161019%3A7%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20161019%3A7; admin_sessionid=eb1e428e6198fd4b568732b78ef9b702"
  url = "https://www.toppr.com/api/v4/class-9/maths/#{chapter.name}/question-bank/?format=json"
  data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)
  # puts data
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
  cookie = "csrftoken=lZKGxtJzec9uIJ3jx0McYWRewnV7Gqo0; _ga=GA1.2.949189307.1476968295; _fp73=ebdd7ad2-8b89-6c94-b899-d369c2ef82b5; ajs_user_id=%221393635%22; ajs_group_id=null; ajs_anonymous_id=%22751ec092-5b52-4c75-aa22-46c4e1ebf419%22; intercom-id-sh7i09tg=054dde12-06c0-4035-a1a4-71e0c6b8315d; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20161019%3A7%7CJGDAMDUE4BESXMWLB6LVSD%3A20161019%3A7%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20161019%3A7; admin_sessionid=eb1e428e6198fd4b568732b78ef9b702"
  url = "https://www.toppr.com/api/v4/class-9/maths/#{chap_name}/question-bank/?format=json'&'page=1'&'difficulty=#{difficulty}'&'goal=#{topic.goal_tid}"
  data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)

  puts "=============== #{data['n_questions']}"
  return data["n_questions"]/10 + 1
end


def get_url chap_name, page, difficulty, topic
  "https://www.toppr.com/api/v4/class-9/maths/#{chap_name}/question-bank/?format=json'&'page=#{page}'&'difficulty=#{difficulty}'&'goal=#{topic.goal_tid}"
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
  2
end
def standard_id
  2
end