require 'net/http'

chapters = ['rational-number', 'linear-equations-in-one-variable', 'understanding-polygons', 'data-handling',
 'squares-and-square-roots', 'cubes-and-cube-roots', 'comparing-quantities', 'algebraic-expressions-and-identities',
  'visualizing-solid-shapes', 'mensuration', 'exponents-and-powers', 'direct-and-inverse-proportions', 'factorisation',
  'introduction-to-graphs', 'playing-with-numbers']


chapters = ['rational-number']
cookie = "csrftoken=lZKGxtJzec9uIJ3jx0McYWRewnV7Gqo0; _ga=GA1.2.949189307.1476968295; _fp73=ebdd7ad2-8b89-6c94-b899-d369c2ef82b5; ajs_user_id=%221393635%22; ajs_group_id=null; ajs_anonymous_id=%22751ec092-5b52-4c75-aa22-46c4e1ebf419%22; intercom-id-sh7i09tg=054dde12-06c0-4035-a1a4-71e0c6b8315d; __ar_v4=VPEPR7JRURDPXMDFMMUNWO%3A20161019%3A7%7CJGDAMDUE4BESXMWLB6LVSD%3A20161019%3A7%7CSTGREAUEC5CBTFLT6ZAOHQ%3A20161019%3A7; admin_sessionid=eb1e428e6198fd4b568732b78ef9b702"


chapters.each do |chap_name|
  if not chapter = Chapter.find_by(:name => chap_name)
    chapter = Chapter.create(:name => chap_name, :subject_id => 1, :standard_id => 1)
  end
  number_of_pages = get_number_of_pages(chap_name)
  puts number_of_pages
  # (1..number_of_pages).each do |page|
  #   url = get_url(chap_name, page)
  #   data = JSON.parse(`curl -v --cookie "#{cookie}" #{url}`)
  #   save_data(data, chapter)
  #   sleep(5)
  # end
end



def get_number_of_pages(chap_name)
  url = "https://www.toppr.com/api/v4/class-8/maths/#{chap_name}/question-bank/?format=json&page=1&difficulty=easy&goal=0"
  data = JSON.parse(`curl -v --cookie "#{cook ie}" #{url}`)
  data["n_questions"]/10
end


def get_url chap_name
  "https://www.toppr.com/api/v4/class-8/maths/#{chap_name}/question-bank/?format=json&page=#{page}&difficulty=easy&goal=0"
end

def save_data(data, chapter)
  return if data["questions"].length == 0
  data["questions"].each do |q|
    
    q_created = ShortChoiceQuestion.create(
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
      :standard_id          => 1,
      :subject_id           => 1
    )

    data["choices"].each do |a|
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




