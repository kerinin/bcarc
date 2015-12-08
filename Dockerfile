FROM ruby:2.2.2-onbuild
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
