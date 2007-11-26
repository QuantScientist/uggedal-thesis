require File.dirname(__FILE__) + '/../typeraker'

task :dev do
  puts Typeraker.config.inspect
end

task :default => 'build:dvi'

task :template => 'template:display'

namespace :template do

  desc 'Displays a base LaTeX file.'
  task :display do
    puts Typeraker::Template.generate
  end

  desc 'Generate a base LaTeX file in the source dir.'
  task :generate do
    Typeraker::Template.create_file
  end
end

task :build => 'build:dvi'

namespace :build do

  desc 'Builds a dvi file of the source files.'
  task :dvi => 'template:generate' do
    Typeraker::Builder::Tex.build
  end

  desc 'Builds a ps file from a dvi file.'
  task :ps => 'build:dvi' do
    Typeraker::Builder::Dvi.build
  end

  task :pdf => 'build:pdf:ps2pdf'

  namespace :pdf do

    desc 'Builds a pdf file from a ps file.'
    task :ps2pdf => 'build:ps' do
      Typeraker::Builder::Ps.build
    end

    desc 'Builds a pdf file from the source files.'
    task :pdflatex => 'template:generate' do
      Typeraker::Builder::Tex.build('pdf')
    end
  end
end


task :view => 'view:dvi'

namespace :view do

  desc 'Views a distributed dvi file.'
  task :dvi => 'build:dvi' do
    Typeraker::Viewer::Dvi.new.launch
  end

  desc 'Views a distributed ps file.'
  task :ps => 'build:ps' do
    Typeraker::Viewer::Ps.new.launch
  end

  task :pdf => 'view:pdf:ps2pdf'

  namespace :pdf do

    desc 'Views a distributed pdf file.'
    task :ps2pdf => 'build:pdf' do
      Typeraker::Viewer::Pdf.new.launch
    end

    desc 'Views a directly distributed pdf file.'
    task :pdflatex => 'build:pdf:pdflatex' do
      Typeraker::Viewer::Pdf.new.launch
    end
  end
end

desc 'Spell checks source files.'
task :spell do
  Typeraker::Spell.check
end
