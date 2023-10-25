
#import "template.typ": *

#set page(margin: (left: 5mm, right: 5mm, top: 7mm, bottom: 7mm))

//#set text(font: "Mulish")
#set text(font: "New Computer Modern")

#show: project.with(
  //theme: rgb(73%, 1%, 0%, 4%),
  first_name: "Maurice",
  last_name: "Debray",
  title: "Student at École Normale Supérieure (ENS)",
  contact: (
    contact(
      text: "(+33) 6 38 23 79 65",
      type: "phone",
    ),
    contact(
      text: "Maurice Debray",
      link: "https://www.github.com/sinavir",
      type: "github",
    ), contact(
      text: "maurice.debray@ens.psl.eu",
      link: "mailto:maurice.debray@ens.psl.eu",
      type: "email",
    ),
  ),
  main: (
    section(content: [
      #set text(size: 1.10em)
      I'm seeking for an internship during the second semester of my M1 year.
    ]),
    section(
      title: "Education",
      content: (
        subSection(
          title: "French high school diploma (Math speciality)",
          titleEnd: "Lycée A. Brizeux",
          subTitle: "June 2019",
          subTitleEnd: "Quimper, Finistère",
          content: [ Obtained with highest honors (>18/20) ],
        ),
        subSection(
          title: "Classe préparatoires aux grandes écoles",
          titleEnd: "Lycée Louis-le-Grand",
          subTitle: "Sept. 2019 – May 2021",
          subTitleEnd: "Paris",
          content: [ Intensive 2-year program to prepare competitive entrance exams to French highly-selective institutions: #list(
            "Mathematics (12h/week) and physics (8h/week) cursus",
            "Programming IT option",
          )],
        ),
        subSection(
          title: "Bachelor degree in Physics",
          subTitle: [2021 -- 2022],
          titleEnd:"ENS",
          subTitleEnd: "Paris",
          content: [
            Last year of Bachelor degree. General physics cursus with following courses: \
            #box(grid(
              columns: (2fr, 3fr),
              column-gutter: 1em,
              list(
                [Quamtum mechanics],
                [Statistical physics],
              ), list(
                [Electromagnetics and special relativity],
                [#sym.dots],
              ),
            ))
          ],
        ),
        subSection(
          title: "Informatic courses during a gap-year",
          subTitle: [2022 -- 2023],
          titleEnd:"ENS",
          subTitleEnd: "Paris",
          content: [
            Courses followed were selected from third-year Bachelor degree of Informatics and Mathematics at ENS: \
            #box(height: 40pt, columns(2)[
            #list(
              [Compilation and programming languages],
              [Numerical systems],
              [Cryptography],
              [Algebra],
              [#sym.dots],
            )
          ])]
        ),
        subSection(
          title: "First-year of Master degree in Physics",
          subTitle: [Sept. 2023 -- Now],
          titleEnd:"ENS",
          subTitleEnd: "Paris",
          content: [
            Current cursus with following courses: \
            #box(height: 40pt, columns(2)[
              #list(
                [Quantum optics],
                [Symmetries in pysics],
                [Introduction to QFT],
                [General Relativity],
                [Quantum matter],
                [#sym.dots],
              )
            ])
          ],
        ),
      ).rev()
    ),
    section(
      title: "Experience",
      content: (
        subSection(
          title: "Instructor at my local Kayak Club",
          subTitle: "Summer 2020",
          subTitleEnd: "Plouhinec, Finistère",
        ),
        subSection(
          title: "Biophysics internship",
          titleEnd: [IBENS],
          subTitle: [June -- July 2022],
          subTitleEnd: "Paris",
          content: [Assembly of a miniature endoscope adapted to mice brain. It was the early steps of the project.],
        ),
        subSection(
          title: "Informatics internship",
          titleEnd: [Commissariat à l'Énergie Atomique (CEA)],
          subTitle: [May -- July 2023],
          subTitleEnd: "Saclay (Paris suburbs)",
          content: [Deploying a binary cache using Nix package manager:
            #list(
              [Desired infrastructure design],
              [CLI implementation to manage cache retention policies],
            )],
        ),
      ).rev()
    ),
    section(content: [
      #v(1fr)
      References available upon request.
    ]),
  ),
  sidebar: (
    section(content: image("photo_id.jpg")),
    section(
      title: "Skills",
      content: (
        subSection(title: "Programing", content: ("Python (Advanced)", "Rust (Beginner)", "C (Intermediate)", "Haskell (Intermediate)", "Latex (Advanced)", "HTML/Javascript (Advanced)",).join(" • ")),
        subSection(title: "Systems", content: ("Linux (Intermediate)", "Nixos (Advanced)", ).join(" • ")),
        subSection(
          title: "Language",
          content: ("French", "English", "Spanish (Notions)",).join(" • "),
        ),
      ),
    ),
    section(
      title: "Hobbies",
      content: (
        subSection(title: "Sports", content: ("Kayak for 7 years",).join(" • "),),
        subSection(title: "Music", content: ("Diatonic accordion", "Piano", "Sousaphone at l'Ernestophone (ENS Brass Band)",).join(" • "),),
        subSection(title: "DIY/Technology", content: [ I love repairing and building things by myself. I also host a bunch of services using NixOS (a niche linux distribution) and maintain some websites for ENS clubs.],),
      ),
    ),
    section(
      title: [Associative Experience],
      content:
        list(
          "Co-organiser of the 2022 ENS Gala",
          "Member of the ENS light and sound association",
          "In charge of ENS students' HackLab (Hackens)",
        ),
    ),
  ),
)
