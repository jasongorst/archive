Account.create!([
                  {
                    # shadylady
                    email: "",
                    password: "kiln.barfly.crewcut.wren",
                    admin: false,
                    user: User.find_by_display_name("shadylady")
                  },
                  {
                    # catnik
                    email: "",
                    password: "jumper.palisade.baldric.lottery",
                    admin: false,
                    user: User.find_by_display_name("catnik")
                  },
                  {
                    # earldebuke
                    email: "",
                    password: "unlucky.late.witless.flung",
                    admin: false,
                    user: User.find_by_display_name("earldebuke")
                  },
                  {
                    # robinrahne
                    email: "",
                    password: "vinyl.maiden.leaden.bury",
                    admin: false,
                    user: User.find_by_display_name("robinrahne")
                  },
                  # {
                  #   # rae
                  #   email: "rae@evilpaws.org",
                  #   password: "huntress.headwind.lock.lighten",
                  #   admin: true,
                  #   user: User.find_by_display_name("rae")
                  # }
                ])
