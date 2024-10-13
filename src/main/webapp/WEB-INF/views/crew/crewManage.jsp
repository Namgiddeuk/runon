<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/js/crew.js" type="text/javascript"></script>

<link rel="stylesheet" href="/css/crewManage.css" type="text/css">

<div>
    <div id="bannerBox">
        <img src="/img/러닝고화질.jpg" id="bannerImg"/>
    </div>
    <input type=hidden id=usercode />
    <div class="content_body">
        <div class="content_left">
            <section class="section3">
                <div class="profile_container">
                    <div class="names">
                        <h1 id='crew_name'></h1>
                        <p id='addr'></p>
                        <p id='crew_info'></p>
                    </div>

                    <div class="profileimage">
                        <div class="imgContainer">
                            <img id=crew_img>
                        </div>
                    </div>
                </div>
                <div class="editCrew">
                    <button type="button" class="editCrewBtn" id="editCrewBtn">크루정보변경</button>
                    <button type="button" class="editCrewBtn" id="resignCrew" onclick="openResignModal()">
                      <img src="/img/more.png" style="width: 14px; height: 14px;">
                    </button>
                </div>
                <div class="statis">
                    <p style="font-weight: 700;">팀원변화</p>
                </div>
            </section>
        </div>
        <div class="content_right">
            <section class="section1">
              <div class="section_nav">
                <ul>
                  <li id=member name=crew_select onClick="crew_manage_select(this)">멤버</li>
                  <li id=notice name=crew_select onClick="crew_manage_select(this)">공지</li>
                  <li id=manage name=crew_select onClick="crew_manage_select(this)">크루관리</li>
                </ul>
              </div>
                  <div class="member">
                    <ul class="member-list" id=crew_manage_list>
                    </ul>
                </div>
            </section>
            <section class="section2">
                <div class="section_title">크루정보</div>
                <div class="info_body">
                    <div class="crew_infos">
                        <span class="crew_imogi">📍</span>
                        <span class="crew_addr">활동지역</span>
                        <span class="crew_addr2" id="addr2"></span>
                    </div>
                    <div class="crew_infos">
                        <span class="crew_imogi">🏃‍</span>
                        <span class="crew_addr">️멤버수</span>
                        <span class="crew_addr2" id=member_cnt></span>
                    </div>
                    <div class="crew_infos">
                        <span class="crew_imogi">🔍‍</span>
                        <span class="crew_addr">평균나이</span>
                        <span class="crew_addr2" id=member_age_avg></span>
                    </div>
                    <div class="crew_infos">
                        <span class="crew_imogi">✨</span>
                        <span class="crew_addr">크루생성일</span>
                        <span class="crew_addr2" id=create_date></span>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>
<!-- 커스텀 모달 창 -->
<div id="customModal" class="custom-modal">
  <div class="custom-modal-content">
    <div class="custom-modal-header">
      <span class="custom-modal-title" id=member_name></span>
      <span class="custom-close" onclick="closeCustomModal()">&times;</span>
    </div>
    <div class="custom-modal-body">
      <button class="custom-modal-option" id="manage2" onClick="member_manage(this)">운영진으로 추가</button>
      <button class="custom-modal-option" id="manage3" onClick="member_manage(this)">일반크루로 변경</button>
      <button class="custom-modal-danger" onClick="openRejectModal();">신고하기</button>
      <button class="custom-modal-danger" id="out" onClick="member_manage(this)">강제 퇴장</button>
    </div>
  </div>
</div>
<!-- 신고 사유 선택 모달-->
<div id="rejectModal" class="custom-modal">
  <div class="custom-modal-content">
    <div class="custom-modal-header">
      <h3 class="modal-title">신고 사유를 선택해주세요</h3>
      <span class="custom-close" onclick="closeRejectModal()">&times;</span>
    </div>
    <div class="custom-modal-body">
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name=report_reason id="reason1" value="1">
        <label class="form-check-label" for="reason1">무단으로 불참했어요 </label>
      </div>
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name=report_reason id="reason2" value="2">
        <label class="form-check-label" for="reason2">시간 약속을 지키지 않아요 </label>
      </div>
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name=report_reason id="reason3" value="3">
        <label class="form-check-label" for="reason3">크루 참여를 위해 속였어요</label>
      </div>
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name=report_reason id="reason4" value="4">
        <label class="form-check-label" for="reason4">매너가 없어요</label>
      </div>
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name=report_reason id="reason5" value="5">
        <label class="form-check-label" for="reason5">광고성 메세지를 보내요</label>
      </div>
    </div>
    <div class="mt-3">
        <textarea id="report_content" name="report" class="report" placeholder="신고 사유를 추가로 작성하실 수 있습니다."></textarea>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="report"  onClick="member_manage(this)">확인</button>
        <button type="button" class="btn btn-light" onclick="closeRejectModal()">취소</button>
    </div>
  </div>
</div>
<--크루정보변경 모달-->
<div id="informationModal" class="custom-modal">
  <div class="custom-modal-content">
    <div class="custom-modal-header">
      <div class="team-info">
        <img id="teamImage" src="/crew_upload/맹고기.jpeg" alt="크루 이미지" />
        <h2 id="teamNameDisplay">크루 이름</h2>
      </div>
      <span class="custom-close" onclick="closeCustomModal()">&times;</span>
    </div>
    <div class="custom-modal-body">
      <button class="custom-modal-option" id=update>프로필 수정</button>
      <button class="custom-modal-option" id=handoverCrewBtn>팀소유자 위임</button>
      <button class="custom-modal-danger" onclick="deleteTeam()" id=crew_delete >팀 삭제하기</button>
    </div>
  </div>
</div>
<!-- 팀 소유자 위임 모달 -->
<div id="handoverModal" class="custom-modal">
  <div class="custom-modal-content">
    <div class="custom-modal-header">
      <h3>위임할 멤버를 선택하세요</h3>
      <span class="custom-close" onclick="closeHandoverModal()">&times;</span>
    </div>
    <div class="custom-modal-body">
      <!-- 팀 멤버 선택 -->
      <label class="team-member">
        <input type="radio"  name="teamOwner" value="jang">
        <img src="/crew_upload/맹고기.jpeg"  class="team-profile">
        <span class="team-name">장재성</span>
      </label>
      <label class="team-member">
        <input type="radio"  name="teamOwner" value="jang">
        <img src="/crew_upload/맹고기.jpeg"  class="team-profile">
        <span class="team-name">장재성</span>
      </label>
    </div>
    <div class="custom-modal-footer">
      <button class="handover-btn" onclick="handoverOwnership()">위임하기</button>
    </div>
  </div>
</div>
<!-- 팀 탈퇴하기 모달 -->
<div id="resignModal" class="custom-modal">
  <div class="custom-modal-content">
    <div class="custom-modal-header">
      <h3 class="modal-title">어떤 걸 하시겠어요?</h3>
      <span class="custom-close" onclick="closeCustomModal()">&times;</span>
    </div>
    <div class="custom-modal-body">
      <button class="custom-modal-danger" onclick="resignTeam()" id="teamResign">팀 탈퇴하기</button>
    </div>
  </div>
</div>
<script>
var Authorization = localStorage.getItem("Authorization");
const urlParams = new URLSearchParams(window.location.search);
const create_crew_code = urlParams.get('create_crew_code');
const user_code = urlParams.get('user_code');
const position = urlParams.get('position');
clog('My position : '+ position);
clog('My user_code : '+ user_code);
    $(document).ready(function() {
        $('#member').css('color', 'black');
        crew_deatil_select();
        crew_manage_select('');
    });

    function crew_deatil_select(){
        $.ajax({
            url: '/crew/crew_deatil_select',
            type: 'post',
            async: false,
            data: {
                Authorization    : Authorization,
                create_crew_code : create_crew_code
            },
            success: function(response) {

                $('#crew_img').attr('src', '/crew_upload/'+response[0].logo);
                $('#crew_name').text(response[0].crew_name);
                $('#addr').text(response[0].addr);
                $('#addr2').text(response[0].addr);
                $('#crew_info').text(response[0].a_s);
                $('#member_cnt').text(response[0].d_n+'명');
                $('#create_date').text(response[0].c_s);
                $('#member_age_avg').text(response[0].e_n+'세');
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }
    function crew_manage_select(element){
         var id = element.id===undefined?'member': element.id;
         $('[name="crew_select"]').css('color', 'gray');
         $('#'+id).css('color', 'black');
        $.ajax({
            url: '/crew/crew_manage_select',
            type: 'post',
            async: false,
            data: {
                Authorization    : Authorization,
                create_crew_code : create_crew_code,
                id               : id
            },
            success: function(response) {
                $('#crew_manage_list').html('');
                if (id=='member')crew_manage_select_member(response);
            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }

    function crew_manage_select_member(response){
        var list ='';
        if(response[0].f_n>0 && response[0].a_n==1){
            list += '<div onClick="go_request_wait()">'
            list += '   <span>';
            list +=         response[0].f_n+'명이 승인을 기다리고있어요.';
            list += '   </span>';
            list += '</div>'
        }
        for(var i in response){
            list += '<li class="member-item"> ';
            list += '<div class="item-flex"> ';
            list += '   <img src="/resources/uploadfile/'+response[i].a_s+'" class="profile-img" onClick="go_mypage('+response[i].usercode+')"> ';
            list += '   <div class="profile-info" onClick="go_mypage('+response[i].usercode+')"> ';
            list += '     <div class="info-wrapper"> ';
            list += '      <p class="name">'+response[i].b_s+'</p> ';
            if(response[i].a_n<3){
                list += '      <div class="label-operator">운영진</div> ';
            }
            list += '     </div> ';
            list += '   </div> ';
            list += '  <div class="menu"> ';
            list += '   <div class="dropdown"> ';
            if(user_code!=response[i].usercode && response[i].b_n>0){
                list += '     <div class="more-icon" onclick="openCustomModal(' + response[i].usercode + ', \'' + response[i].nickname + '\', \'' + response[i].a_n + '\')"> <img src="/img/dots.png" alt="dots icon" style="width: 20px; height: 20px;"></div> ';
            }
            list += '   </div> ';
            list += '  </div> ';
            list += '</div> ';
            list += '</li> ';
        }


        $('#crew_manage_list').append(list);
    }
    function openCustomModal(usercode,nickname,user_pisition) {
      $('#usercode').val(usercode);
      $('#member_name').text(nickname);
      if(position==1){
        $('#manage2').show();
        $('#manage3').show();
        $('#out').show();
      }
      else{
        $('#manage2').hide();
        $('#manage3').hide();
        $('#out').hide();
      }
      clog(user_pisition);
      if(user_pisition==2)$('#manage2').hide();
      if(user_pisition==3)$('#manage3').hide();

      document.getElementById('customModal').style.display = 'block';
    }
    function go_request_wait(){
        window.location.href = '/crew/crewApp?create_crew_code=' + create_crew_code + '&position=' + position;
    }
    function go_mypage(usercode){
        window.location.href = '/mypage/myHome?usercode=' + usercode;
    }
    function member_manage(element){
        var id = element.id;
        var reason='';
        var checkedValues = [];
        clog(id);
        if(id=='report'){
            $('input[name="report_reason"]:checked').each(function() {
                checkedValues.push($(this).val());
            });
            reason = checkedValues.join(',');
        }
        $.ajax({
            url: '/crew/member_manage',
            type: 'post',
            async: false,
            data: {
                Authorization    : Authorization,
                create_crew_code : create_crew_code,
                id               : id,
                usercode         : $('#usercode').val(),
                reason           : reason,
                reason_text      : $('#report_content').val()
            },
            success: function(response) {
                if(response==1) alert('운영진으로 추가되었습니다.');
                if(response==4) alert('일반크루로 변경되었습니다.');
                if(response==2) alert('신고접수가 되었습니다.');
                if(response==3) alert('유저가 강퇴되었습니다.');
                location.reload(true);

            },
            error: function(e) {
                console.error('Error: ', e);
            }
        });
    }

//신고 사유 선택 모달 열기
  function openRejectModal() {
    document.getElementById("rejectModal").style.display = "block";
  }

  //신고 사유 선택 모달 열기
    function openRejectModal() {
      document.getElementById("rejectModal").style.display = "block";
    }

    // 신고 사유 선택 모달 닫기
    function closeRejectModal() {
      document.getElementById("rejectModal").style.display = "none";
    }
    // 신고 사유 확인 처리
    function confirmRejection() {
      alert("신고 사유가 제출되었습니다.");
      closeRejectModal();
    }

      // 크루정보변경 버튼 클릭 시 모달 열기
      document.getElementById("editCrewBtn").addEventListener("click", function() {
        document.getElementById("informationModal").style.display = "block";
      });

      // 팀 소유자 위임 모달 열기 (informationModal 닫고 handoverModal 열기)
      document.getElementById("handoverCrewBtn").addEventListener("click", function() {
        document.getElementById("informationModal").style.display = "none"; // 정보 변경 모달 닫기
        document.getElementById("handoverModal").style.display = "block"; // 팀 소유자 위임 모달 열기
      });

      // handoverModal의 닫기 버튼을 눌렀을 때 handoverModal을 닫고, 다시 informationModal 열기
      function closeHandoverModal() {
        document.getElementById("handoverModal").style.display = "none"; // handoverModal 닫기
        document.getElementById("informationModal").style.display = "block"; // informationModal 다시 열기
      }

      // 위임하기 버튼 클릭 시 handoverModal 닫고 다시 informationModal 열기
      function handoverOwnership() {
        // 위임 로직 추가 (예: 서버 요청)
        alert("팀 소유자가 위임되었습니다.");
        closeHandoverModal(); // handoverModal을 닫고, informationModal 다시 열기
      }

      // 기존 모달 닫기 함수
      function closeCustomModal() {
        document.getElementById("customModal").style.display = "none";
        document.getElementById("informationModal").style.display = "none";
        document.getElementById("customModal").style.display = "none";
        document.getElementById("resignModal").style.display = "none";
      }

      // 팀 탈퇴 모달 열기
      function openResignModal() {
        document.getElementById("resignModal").style.display = "block";
      }
      // 팀 탈퇴 처리 함수 (필요에 따라 서버 요청 등 추가 가능)
      function resignTeam() {
        alert("팀에서 탈퇴되었습니다.");
        closeResignModal();
      }





</script>