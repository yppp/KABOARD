$ ->
        $.ajaxSetup
        $(".spinner img").css("display", "none");
        getpost = ->
                $.get "board",  (data) ->
                        $(".comment").remove()
                        $(".comments").append("<div class = 'comment'> <div class = 'info'> <h2>" + i.title + "</h2> <span class = 'auther'>by "+ i.auther + "</span> <span class = 'date'>" + i.posted_date + "</span> </div> <div class = 'message'>" + i.body + "</div> </div>") for i in data

        window.setInterval ->
                $(".spinner img").css("display", "block");
                getpost()
                $(".spinner img").css("display", "none");
        , 10000

        $("#comment-form").submit ->
                $('#mit').attr("disabled", "disabled");
                $(".spinner img").css("display", "block")
                $.post '/comment'
                        "name": $("#name").val()
                        "title": $("#title").val()
                        "message": $("#message").val()
                        (data) ->
                                getpost()
                                $(".spinner img").css("display", "none")
                                $("#name").val ""
                                $("#title").val ""
                                $("#message").val ""
                                $('#mit').removeAttr("disabled")
                false
