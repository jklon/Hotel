namespace :extramarks do
  task :lol => :environment do
    chapters = ['1458', '1457', '1459', '1460', '1462', '1461', '1453', '1454', '1456', '1465', '1464', '1463', '1455', '1466']

    # chapters = ['1458']

    chapters.each do |chap_id|
      chapter_details = get_chapter_details chap_id
      if not chapter = Chapter.where(chapter_details).last
        chapter = Chapter.create(chapter_details)
      end

      (1..10).each do |page_number|
        data = JSON.parse(`curl -v --cookie "#{get_cookie}" #{get_extramarks_url(page_number, chap_id)}`)
        puts "========================================== #{get_extramarks_url(page_number, chap_id)} =============================================="
        save_extramarks_data(data, chapter)
        x = Random.rand(10)
        puts x
        sleep(x)
      end

    end

  end
end

def save_extramarks_data data, chapter
  return if data["data"].length == 0
  data["data"].each do |all_data|
    
    q = all_data["questiondata"]
    next if ExtraMarksQuestion.find_by(:em_question_id => q["questionid"])
    
    q_created = ExtraMarksQuestion.create(
      :em_question_id     => q["questionid"],
      :question_type      => q["questiontype"],
      :answer_description => q["explanatation"],
      :question_text      => q["question"],
      :answer_type        => q["answerType"],
      :difficulty         => q["difficulty_category"],
      :level              => q["ques_difficulty"],
      :chapter_id         => chapter.id,
      :standard_id        => extramarks_standard_id,
      :subject_id         => extramarks_subject_id
    )

    next if not (all_data["optiondata"] and all_data["optiondata"]["options"])
    
    all_data["optiondata"]["options"].each do |option|
      ExtraMarksAnswer.create(
        :extra_marks_question_id => q_created.id,
        :answer_text             => option["optiontext"],
        :label                   => option["anstype"],
        :em_answer_id            => option["optionid"]
      )
    end

    next if not (all_data["rightanswerdata"] and all_data["rightanswerdata"]["rightanswer"])

    all_data["rightanswerdata"]["rightanswer"].each do |correct_answer|
      if answer = q_created.extra_marks_answers.find_by(:em_answer_id => correct_answer["answerid"])
        answer.update(:correct => true)
      end
    end

  end
end

def get_chapter_details chap_id
  data =  JSON.parse(`curl -v --cookie "#{get_cookie}" #{get_extramarks_url(1, chap_id)}`)
  {:name => data["title"], :standard_id => extramarks_standard_id, :subject_id => extramarks_subject_id}
end

def get_extramarks_url page_number, chap_id
  "http://www.extramarks.com/lms/json/getquestions/#{chap_id}/2296/multiple/#{page_number}"
end

def extramarks_subject_id
  3
end

def extramarks_standard_id
  3
end

def get_cookie
  "PHPSESSID=v5nbh2a98ni3rt9af29pfgius1; user_ipAddress=60152289-124.155.244.106; user_randomValue=60152289; tracker_id=797508; c181625523-53316ic=c320714-24386-86750; _ga=GA1.2.120098453.1477652835; __zlcmid=dKfxUQBZJHb1w9; email=neeraj%40doormint.in; password=neeraj; remember=true; PRUM_EPISODES=s=1477656051744&r=http%3A//www.extramarks.com/website/index/dashboard/32%23/chapterDetails/1458; _dc_gtm_UA-54609455-1=1"
end