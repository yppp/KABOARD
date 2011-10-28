$ ->

        getpost = ->
                $.get "board",  (data) ->
                        $(".comment").remove()
                        $(".comments").append("<div class = 'comment'> <div class = 'info'> <h2>" + i.title + "</h2> <span class = 'auther'>by "+ i.auther + "</span> <span class = 'date'>" + i.posted_date + "</span> </div> <div class = 'message'>" + i.body + "</div> </div>") for i in data

        window.setInterval ->
                $(".spinner").append('<img src = "indicator.white.gif">')
                getpost()
                $(".spinner img").remove()
        , 5000

        $("#comment-form").submit ->
                $('input').attr("disabled", "disabled");
                $.ajax
                        type: 'POST'
                        url: '/comment'
                        data: {"name": $("#name").val(), "title": $("#title").val(), "message": $("#message").val()}
                        success: ->
                                $(".spinner").append('<img src = "indicator.white.gif">')
                                getpost()
                                $(".spinner img").remove()
                                $("#name").val ""
                                $("#title").val ""
                                $("#message").val ""
                                $('input').removeAttr("disabled");

                false