$ ->
        $(".spinner img").css("display", "none");
        getpost = ->
                $.get "board",  (data) ->
                        $(".comment").remove()
                        $(".comments").append("<div class = 'comment'> <div class = 'info'> <h2>" + i.title + "</h2> <span class = 'auther'>by "+ i.auther + "</span> <span class = 'date'>" + i.posted_date + "</span> </div> <div class = 'message'>" + i.body + "</div> </div>") for i in data

        window.setInterval ->
                $(".spinner img").css("display", "block");
                getpost()
                $(".spinner img").css("display", "none");
        , 5000

        $("#comment-form").submit ->
                $(".errors p").text("")
                $('#mit').attr("disabled", "disabled");
                $(".spinner img").css("display", "block")
                $.post '/comment'
                        "name": $("#name").val()
                        "title": $("#title").val()
                        "message": $("#message").val()
                        (data) ->
                                setTimeout ->
                                        true
                                ,1000
                                if data.auther or data.body
                                        $(".errors p.auther").text(data.auther[0]) if data.auther
                                        $(".errors p.body").text(data.body[0]) if data.body
                                else
                                        getpost()
                                        $("#title").val ""
                                        $("#message").val ""

                                $(".spinner img").css("display", "none")
                                $('#mit').removeAttr("disabled")

                ,"JSON"
                false
