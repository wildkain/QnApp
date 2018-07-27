class NotifySubscribersAboutAnswersMailer < ApplicationMailer

  def notify(user, answer)
    @user = user
    @answer = answer
    @question = @answer.question

    mail to: @user.email, subject: "Question #{@answer.question.title} get new answer!"
  end
end
