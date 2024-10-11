<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="/css/mypage.css" type="text/css">
<!--회원정보수정 css/js -->
<link rel="stylesheet" href="/css/mypage/editProfileModal.css" type="text/css">
<script src="/js/login&join/JoinForm.js" type="text/javascript"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


<style>

    .modal {
        display: none;  /* 처음에는 숨겨둠 */
        position: fixed;
        z-index: 1;  /* 모달이 다른 요소들 위에 표시되도록 설정 */
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgb(0,0,0);  /* 반투명한 배경 */
        background-color: rgba(0,0,0,0.4);  /* 반투명한 배경 */
    }

    .modal-content {
        background-color: #fefefe;
        margin: 15% auto;
        padding: 20px;
        border: 1px solid #888;
        width: 30%;  /* 모달의 너비 설정 */
        border-radius: 15px;
    }

    .close-button {
        color: #aaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
    }

    .close-button:hover,
    .close-button:focus {
        color: black;
        text-decoration: none;
        cursor: pointer;
    }
    .modal {
        z-index: 1000;  /* 다른 요소들 위에 모달을 표시 */
    }

</style>
<script>
    //QnA 이동
    function openQnA(){
        username = username1
        usercode = usercode1
        $.ajax({
            url: "/mypage/openmyQnA",
            type: "post",
            data: {username:username,
                    usercode: usercode},
            success: function(r){
                location.href="/mypage/myQnA";
            },error: function(e){
                alert("이동실패..");
                console.log(e);
            }
        })
    }
    //나의 메이트 이동
    function openMymate(){
        username=username1
        $.ajax({
            url: "/mypage/openMymate",
            type: "Post",
            data: {username:username},
            success: function(r) {
                location.href = "/mypage/myMate";
            },
            error: function(e) {
                console.log(e);
                alert("으으");
            }
        });
    }
    //내 기록인증하기로 이동
    function openCertificate(){
        username=username1
            $.ajax({
                url: "/mypage/certificate",
                type: "Post",
                data: {username:username},
                success: function(r) {
                    alert("성공");
                    location.href = "/mypage/certificateList";
                },
                error: function(e) {
                    console.log(e);
                    alert("으으");
                }
            });

    }

    //마라톤신청서수정모달열기
    function openEditMarathonFormModal(){
        var modal = document.getElementById("editMarathonFormModal");
        if(modal){
            modal.style.display="block";

        }else{
            console.error("실패");
        }
    }
    //마라톤신청서수정모달닫기
    function closeEditMarathonFormModal(){
        var modal = document.getElementById("editMarathonFormModal");
        if (modal) {
            modal.style.display = "none";  // 모달을 숨김
        } else {
            console.error("Modal element not found: " + modalId);
        }
    }
    //마라톤신청서모달열기
    function openMarathonFormModal(){
        var modal = document.getElementById("openMarathonFormModal");
        if(modal){
            modal.style.display="block";

        }else{
            console.error("실패");
        }
    }
    //마라톤신청서모달닫기
    function closeMarathonFormModal(){
        var modal = document.getElementById("openMarathonFormModal");
        if (modal) {
            modal.style.display = "none";  // 모달을 숨김
        } else {
            console.error("Modal element not found: " + modalId);
        }
    }

    //마라톤신청서 존재여부
    function checkMarathonForm(){

        $.ajax({
            url: "/mypage/marathonFormCheck",
            data: {usercode:usercode1},
            success: function(r){
                if(r.exists){
                    var data22=r.data;
                    alert("기존에 작성한 신청서가 있습니다.")
                    console.log(r.data);
                    var modal = document.getElementById("editMarathonFormModal");
                    if(modal){
                        document.getElementById("rname").value = r.data.name;
                        document.getElementById("rtel").value = r.data.name;
                        document.getElementById("rname").value = r.data.name;
                        modal.style.display = "block";
                    }

                }else{
                    alert("신청서를 작성해주세요.")
                    openMarathonFormModal();
                }
            },error: function (e){
                console.log(e);
            }
        })
    }
    //마라톤 수정/삭제 모달열기
    // function openEditMarathonFormModal(data){
    //     console.log("11"+data);
    //     var modal = document.getElementById("editMarathonFormModal");
    //     if(modal){
    //         document.getElementById("name").value = data.name;
    //
    //         modal.style.display = "modal";
    //     }
    // }
    //마라톤 신청서 작성폼 전송
    function submitMarathonForm(){
        const formData = {

            name: document.getElementById("name").value,
            tel: document.getElementById("tel").value,
            addr: document.getElementById("addr").value,
            addr_details: document.getElementById("addr_details").value,
            gender: document.getElementById("gender").value,
            birth_date: document.getElementById("birth_date").value,
            size: document.getElementById("size").value,
            terms_agreement: document.getElementById("terms_agreement").checked ? 1 : 0,  // boolean을 int로 변환
            privacy_consent: document.getElementById("privacy_consent").checked ? 1 : 0,  // boolean을 int로 변환
            media_consent: document.getElementById("media_consent").checked ? 1 : 0  // boolean을 int로 변환
        };
        console.log(formData);
        var token = localStorage.getItem("Authorization");
        if(token != "" && token != null) {
            $.ajax({
                url: "/mypage/createMarathonForm",
                type: "post",

                data: {usercode:usercode1,
                    name: document.getElementById("name").value,
                    tel: document.getElementById("tel").value,
                    addr: document.getElementById("addr").value,
                    addr_details: document.getElementById("addr_details").value,
                    gender: document.getElementById("gender").value,
                    birth_date: document.getElementById("birth_date").value,
                    size: document.getElementById("size").value,
                    terms_agreement: document.getElementById("terms_agreement").checked ? 1 : 0,  // boolean을 int로 변환
                    privacy_consent: document.getElementById("privacy_consent").checked ? 1 : 0,  // boolean을 int로 변환
                    media_consent: document.getElementById("media_consent").checked ? 1 : 0  // boolean을 int로 변환
                    },
                success: function (r) {
                    alert("마라톤신청서 작성이 완료되었습니다.");
                    closeMarathonFormModal();
                    //location.reload();
                }, error: function (e) {
                    console.log(e);
                    alert("마라톤신청서 작성이 실패했습니다.");
                    return false;

                }
            })
        }
        return false;
    }
    //마라톤 신청서 수정폼전송
    function submitEditMarathonForm(){
        var formData = {
            name: document.getElementById("name").value,
            tel: document.getElementById("tel").value,
            addr: document.getElementById("addr").value,
            addr_details: document.getElementById("addr_details").value,
            gender: document.getElementById("gender").value,
            birth_date: document.getElementById("birth_date").value,
            size: document.getElementById("size").value,
            Authorization: token
        };
        $.ajax({
            url: "/mypage/updateMarathonForm",
            type: "post",
            data: formData,
            success: function(r){
                alert("신청서가 수정되었습니다.");
                location.reload();
            },error: function(e){
                alert("신청서 수정에 실패했습니다.");
                console.log(e);
            }
        })
    }

    //마라톤신청서삭제
    function deleteMarathonForm(){
        $.ajax({
            url: "/mypage/deleteMarathonForm",
            type: "post",
            success: function(r){
                alert("신청서가 삭제되었습니다.");
                location.reload();
            },error: function (e){
                alert("신청서 삭제에 실패했습니다.");
                console.log(e);
            }
        })

    }
    // 회원탈퇴모달 닫기
    function closeDeleteProfileModal() {
        var modal = document.getElementById("profileDeleteModal");
        if (modal) {
            modal.style.display = "none";  // 모달을 숨김
        } else {
            console.error("Modal element not found: " + modalId);
        }
    }
    //회원탈퇴 모달띄우기
    function openDeleteProfileModal(){
        var modal = document.getElementById("profileDeleteModal");
        if(modal){
            modal.style.display="block";
        }else{
            console.error("실패");
        }
    }
    //회원탈퇴 폼 전송
    function submitDeleteProfile(){
        var token = localStorage.getItem("Authorization");
        var deletePassword = document.getElementById("deletePassword").value;

        if(token && deletePassword){
            $.ajax({
                url: "/mypage/deleteProfile",
                type: "post",
                data: {currentPassword: deletePassword},
                headers: {Authorization: token},
                success: function(r){
                    alert("회원탈퇴가 완료되었습니다.");
                    localStorage.removeItem("Authorization");
                    closeDeleteProfileModal();
                    location.href = "/";
                },error: function(e){
                    alert("회원탈퇴에 실패했습니다. 비밀번호를 확인해주세요.");
                    console.log(e);
                }
            })
        }
        return false;
    }
    // 회원정보수정 모달 열기
    function openModal(profileEditModal) {
        var modal = document.getElementById("profileEditModal");
        if (modal) {
            modal.style.display = "block";  // 모달을 화면에 보이도록 설정
        } else {
            console.error("Modal element not found: " + modalId);
        }
    }
    // 회원정보수정 모달 닫기
    function closeModal(profileEditModal) {
        var modal = document.getElementById("profileEditModal");
        if (modal) {
            modal.style.display = "none";  // 모달을 숨김
        } else {
            console.error("Modal element not found: " + modalId);
        }
    }
    //회원정보 모달 띄우기
    function openEditProfileModal(){
        var token = localStorage.getItem("Authorization");
        if(token != "" && token != null) {
            $.ajax({
                url: "/mypage/myHome",  // 사용자 정보를 불러오는 API 경로
                type: "post",
                data: {Authorization: token},
                success: function (r) {
                    var nameInput = document.getElementById("username");
                    var name = document.getElementById("name");
                    var birthdate = document.getElementById("birthdate");
                    var gender = document.getElementById("gender");
                    var nickname = document.getElementById("nickname");
                    var tel1 = document.getElementById("tel1");
                    var tel2 = document.getElementById("tel2");
                    var tel3 = document.getElementById("tel3");
                    if (nameInput) {  // 요소가 존재하는지 확인
                        nameInput.value = r.username;
                        name.value = r.name;
                        birthdate.value = r.birthdate;
                        gender.value = r.gender;
                        nickname.value = r.nickname;
                        tel1.value = r.tel1;
                        tel2.value = r.tel2;
                        tel3.value = r.tel3;
                        openModal("profileEditModal");  // 모달을 띄움
                    }
                },
                error: function (e) {
                    alert("회원정보를 불러오는데 실패했습니다.");
                    console.log(e);
                }
            });
        }
    }
    //회원정보 수정폼전송
    function submitEditProfile(){
        var token = localStorage.getItem("Authorization");
        var formData = {
            name: document.getElementById("name").value,
            currentPassword: document.getElementById("currentPassword").value,
            newPassword: document.getElementById("newPassword").value,
            newPasswordConfirm: document.getElementById("newPasswordConfirm").value,
            nickname: document.getElementById("nickname").value,
            tel1: document.getElementById("tel1").value,
            tel2: document.getElementById("tel2").value,
            tel3: document.getElementById("tel3").value,
            Authorization:token

        };
        console.log(formData);
        // 새 비밀번호 확인
        if (formData.newPassword !== formData.newPasswordConfirm) {
            alert("새 비밀번호가 일치하지 않습니다.");
            return false;
        }

        if(token != "" && token != null){
            $.ajax({
                url: "/mypage/editProfile",
                type: "post",
                data: formData,
                success: function(r){
                    alert("회원정보가 수정되었습니다.");
                    closeModal("profileEditModal");
                    location.reload();
                },error(e){
                    alert("회원정보 수정에 실패하였습니다.");
                    console.log(e);
                }
            })
        }
        return false;
    }
    //구매내역이동
    function getPurchaseList(){
        $.ajax({
            url:"/mypage/purchaseList",
            success:function(r){
                //console.log(r);
                //location.href=r;
                location.href="/mypage/purchaseList";
            },error:function (e){
                console.log(e);
            }
        })
    }
    //formData 생성
    function getProfileFormData(){
        var formData = new FormData();
        var fileInput = document.getElementById('fileInput');
        formData.append("profile_img", fileInput.files[0]);
        return formData;
    }
    //프로필 이미지 폼 전송
    function submitProfile(){
        var token = localStorage.getItem("Authorization");
        if (token != "" && token !=null){
            var formData = getProfileFormData(); //formData 생성
            $.ajax({
                url:"/mypage/updateProfile",
                type: "post",
                data: formData,
                processData: false,
                contentType: false,
                headers: {Authorization: token},
                success: function(r){
                    alert("프로필이 변경되었습니다.");
                    location.reload();
                },error(e){
                    alert("프로필 변경이 실패했습니다.");
                    console.log(e);
                }
            })
        }
    }
    //페이지 로드시 사용자 정보(왼쪽)를 불러옴
    $(document).ready(function() {
        var token = localStorage.getItem("Authorization");
        if(token != "" && token != null){
            $.ajax({
                url: "/mypage/myHome",
                type:"post",
                data:{Authorization:token},
                success: function (r){
                    username=r;
                    var mypoint = r.mypoint ? r.mypoint : 0;
                    tag="";
                    tag += `
                        <div class="content_body">
                            <div class="content_left">
                                <section class="section3">
                                    <div id="leftpart">
                                        <div class="profile_container">
                                            <div class="names">
                                                <h1>`+r.name+`님</h1>
                                                <p>`+r.username+`</p>
                                            </div>
                                            <div class="profileimage">
                                                <div class="imgContainer">
                                                    <img src="/resources/uploadfile/`+r.profile_img+`">
                                                </div>
                                                <form id="profileForm" method="post" action="/mypage/updateProfile" enctype="multipart/form-data">
                                                    <input type="file" id="fileInput" name="profile_img" accept="image/*" onchange="submitProfile()" style="display:none;">
                                                    <button type="button" onclick="document.getElementById('fileInput').click();" style="background: none; border: none; padding: 0;">
                                                        <img src="/img/EditIcon.png" class="editIcon">
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                        <div class="mystatus">
                                            <li class="status_items">
                                                <div class="status_label">
                                                    <p>나의 랭킹🏃‍♀️</p>
                                                    <p>123위</p>
                                                </div>
                                            </li>
                                            <li class="status_items">
                                                <div class="status_label">
                                                    <p>나의 포인트🪙</p>
                                                    <p>`+mypoint+`</p>
                                                </div>
                                            </li>
                                        </div>
                                    </div>
                                </section>
                            </div>
                            <div class="content_right">
                                <section class="section1">
                                    <div class="section_title">나의 런온</div>
                                    <div class="section_menu">
                                        <ul class="menu_list">
                                            <li>
                                                <a onclick="getPurchaseList()">
                                                    <div class="list_container" >
                                                        <p class="icons">💰</p>
                                                        <p class="list_title">구매내역</p>
                                                    </div>
                                                </a>
                                            </li>
                                            <li>
                                                <a onclick="checkMarathonForm()">
                                                    <div class="list_container">
                                                        <p class="icons">📜</p>
                                                        <p class="list_title">마라톤 신청서</p>
                                                    </div>
                                                </a>
                                            </li>
                                            <li>
                                                <a onclick="openCertificate()">
                                                    <div class="list_container">
                                                        <p class="icons">✍️</p>
                                                        <p class="list_title">내 기록 인증하기</p>
                                                    </div>
                                                </a>
                                            </li>
                                            <li>
                                                <a onclick="openMymate()">
                                                    <div class="list_container">
                                                        <p class="icons">🤼‍♂️</p>
                                                        <p class="list_title">나의 메이트</p>
                                                    </div>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </section>
                                <section class="section2">
                                    <div class="section_title">설정</div>
                                    <div class="section_menu">
                                        <ul class="menu_list">
                                            <li>
                                                <a onclick="openQnA()">
                                                    <div class="list_container">
                                                        <p class="icons">❓</p>
                                                        <p class="list_title">내 QnA</p>
                                                    </div>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="">
                                                    <div class="list_container">
                                                        <p class="icons">💳</p>
                                                        <p class="list_title">결제수단추가</p>
                                                    </div>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="javascript: void(0)" onclick="openEditProfileModal()">
                                                    <div class="list_container">
                                                        <p class="icons">⚙️</p>
                                                        <p class="list_title">회원정보 수정</p>
                                                    </div>
                                                </a>
                                            </li>
                                            <li>
                                                <a onclick="openDeleteProfileModal()">
                                                    <div class="list_container">
                                                        <p class="icons">😥</p>
                                                        <p class="list_title" style="color: tomato;">회원탈퇴</p>
                                                    </div>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </section>
                            </div>
                        </div>
                    `
                    document.getElementById("contentAll").innerHTML=tag;


                }
            })
        }
    });
    function passwordChk(){
        var currentPassword = document.getElementById("currentPassword");
        var username = document.getElementById("username");
        $.ajax({
            url:"/mypage/passwordChk",
            type:"post",
            data: {
                currentPassword: currentPassword,
                username: username
            },success: function(r){
                r="1or0?";
                if (r==1){
                    document.getElementById("id").value="Y"
                }
                if (r==0){

                }

                alert("성공");
            }
        })
    }
</script>
<div>
    <div id="bannerBox">
        <img src="/img/러닝고화질.jpg" id="bannerImg"/>
    </div>
    <div id="contentAll">
        <!--token을 불러와 마이페이지 로드-->

    </div>
    <!-- 마라톤신청서작성모달-->
    <div id="openMarathonFormModal" class="modal" style="display:none;">
        <div class="modal-content" style="width: 20%;">
            <span class="close-button" onclick="closeMarathonFormModal()">&times;</span>
            <h2 style="text-align: center">마라톤신청서 작성</h2>
            <form method="POST" action="" onsubmit="return submitMarathonForm()" >
                <div>
                    <label for="name">이름:</label>
                    <input type="text" id="name" name="name" maxlength="30" required />
                </div>
                <div>
                    <label for="tel">전화번호:</label>
                    <input type="tel" id="tel" name="tel" maxlength="15" required />
                </div>
                <div>
                    <label for="addr">주소:</label>
                    <input type="text" id="addr" name="addr" maxlength="100" required />
                </div>
                <div>
                    <label for="addr_details">상세 주소:</label>
                    <input type="text" id="addr_details" name="addr_details" maxlength="300" required />
                </div>
                <div>
                    <label for="gender">성별:</label>
                    <select id="gender" name="gender" required>
                        <option value="M">남성</option>
                        <option value="F">여성</option>
                    </select>
                </div>
                <div>
                    <label for="birth_date">생년월일:</label>
                    <input type="date" id="birth_date" name="birth_date" required />
                </div>
                <div>
                    <label for="size">사이즈:</label>
                    <input type="text" id="size" name="size" maxlength="30" required />
                </div>
                <div>
                    <label for="terms_agreement">이용약관 동의:</label>
                    <input type="checkbox" id="terms_agreement" name="terms_agreement" required />
                </div>
                <div>
                    <label for="privacy_consent">개인정보 수집 동의:</label>
                    <input type="checkbox" id="privacy_consent" name="privacy_consent" required />
                </div>
                <div>
                    <label for="media_consent">미디어 사용 동의:</label>
                    <input type="checkbox" id="media_consent" name="media_consent" />
                </div>
                <div>
                    <button type="submit">신청하기</button>
                </div>
            </form>
        </div>
    </div>
    <!-- 마라톤신청서수정/삭제모달-->
    <div id="editMarathonFormModal" class="modal" style="display:none;">
        <div class="modal-content" style="width: 20%;">
            <span class="close-button" onclick="closeEditMarathonFormModal()">&times;</span>
            <h2 style="text-align: center">마라톤신청서 수정</h2>
            <form onsubmit="return submiteditMarathonForm()" method="POST">
                <div>
                    <label for="name">이름:</label>
                    <input type="text" id="rname" name="name" maxlength="30" required />
                </div>
                <div>
                    <label for="tel">전화번호:</label>
                    <input type="tel" id="rtel" name="tel" maxlength="15" required />
                </div>
                <div>
                    <label for="addr">주소:</label>
                    <input type="text" id="raddr" name="addr" maxlength="100" required />
                </div>
                <div>
                    <label for="addr_details">상세 주소:</label>
                    <input type="text" id="raddr_details" name="addr_details" maxlength="300" required />
                </div>
                <div>
                    <label for="gender">성별:</label>
                    <select id="rgender" name="gender" required>
                        <option value="M">남성</option>
                        <option value="F">여성</option>
                    </select>
                </div>
                <div>
                    <label for="birth_date">생년월일:</label>
                    <input type="date" id="rbirth_date" name="birth_date" required />
                </div>
                <div>
                    <label for="size">사이즈:</label>
                    <input type="text" id="rsize" name="size" maxlength="30" required />
                </div>
                <div>
                    <label for="terms_agreement">이용약관 동의:</label>
                    <input type="checkbox" id="rterms_agreement" name="terms_agreement" required />
                </div>
                <div>
                    <label for="privacy_consent">개인정보 수집 동의:</label>
                    <input type="checkbox" id="rprivacy_consent" name="privacy_consent" required />
                </div>
                <div>
                    <label for="media_consent">미디어 사용 동의:</label>
                    <input type="checkbox" id="rmedia_consent" name="media_consent" />
                </div>
                <div>
                    <button type="submit">수정하기</button>
                    <button type="button" onclick="deleteMarathonForm()">삭제하기</button>
                </div>
            </form>
        </div>
    </div>

    <!--회원정보수정모달-->
    <div id="profileEditModal" class="modal" style="display:none;">
        <div class="modal-content" style="width: 20%;">
            <span class="close-button" onclick="closeModal('profileEditModal')">&times;</span>
            <h2 style="text-align: center">회원정보 수정</h2>
            <form method="post" id="editProfileForm" onsubmit="return formCheck()" >
                <div class="joinMain">
                    <div class="joinN">아이디<span>(이메일)</span></div>
                    <div class="joinI">
                        <input type="text" name="username" id="username" value="userid" readonly/>
                    </div>
                    <div class="joinN">기존 비밀번호</div>
                    <div class="joinI">
                        <input type="password" name="currentPassword" id="currentPassword" onfocusout="passwordChk()" placeholder="기존 비밀번호를 입력해주세요." required/>
                        <input type ="hidden" value="N">
                    </div>
                    <div class="joinN">새 비밀번호</div>
                    <div class="joinI">
                        <input type="password" name="newPassword" id="newPassword" placeholder="변경할 비밀번호를 입력해주세요."/>
                    </div>
                    <div class="joinN">새 비밀번호확인</div>
                    <div class="joinI">
                        <input type="password" name="newPasswordConfirm" id="newPasswordConfirm" placeholder="변경할 비밀번호를 재입력해주세요"/>
                    </div>
                    <div class="joinN">이름</div>
                    <div class="joinI">
                        <input type="text" name="name" id="name" value="name" disabled/>
                        <input type="button" value=" 남 " id="genderm" onclick="gendercheck(this.value)" disabled/>
                        <input type="button" value=" 여 " id="genderw" onclick="gendercheck(this.value)" disabled/>
                        <input type="hidden" name="gender" id="gender" value="gender" disabled/>
                    </div>
                    <div class="joinN">생년월일</div>
                    <div class="joinI">
                        <input type="text" name="birthdate" id="birthdate" value="birthdate" disabled/>
                    </div>
                    <div class="joinN">닉네임</div>
                    <div class="joinI">
                        <input type="text" name="nickname" id="nickname" onblur="nicknamecheck()" value="nickname"/>
                        <input type="hidden" name="nickChk" id="nickChk" value="N">
                    </div>
                    <div id="nickCheck" style="font-size: 0.8em;"></div>
                    <div class="joinN">연락처</div>
                    <div class="joinT">
                        <select name="tel1" id="tel1" value="tel1">
                            <option>010</option>
                            <option>02</option>
                            <option>031</option>
                            <option>051</option>
                        </select> -
                        <input type="text" name="tel2" id="tel2" size="4"  minlength="3" maxlength="4" value="tel2"/> -
                        <input type="text" name="tel3" id="tel3" size="4" maxlength="4" value="tel3"/>
                        <input type="hidden" name="tel" id="tel">
                    </div>
                    <div class="joinN">우편번호</div>
                    <div class="joinZ">
                        <input type="text" name="zip_code" id="zip_code" size="5" placeholder="선택사항"/>
                        <input type="button" id="zipSearch" value="우편변호찾기" onclick="daumPostcode()"/>
                    </div>
                    <div class="joinN">주소</div>
                    <div class="joinI">
                        <input type="text" name="addr" id="addr" style="width:70%" placeholder="선택사항입니다"/>
                    </div>
                    <div class="joinN">상세주소</div>
                    <div class="joinI">
                        <input type="text" name="addr_details" id="addr_details" placeholder="선택사항입니다"/>
                    </div>
                    <div class="joinN info">개인정보 공개여부
                        <div class="form-check" style="color: #899cb5;">
                            <input type="radio" class="form-check-input" id="radio1" name="is_info_disclosure" value="Y" >공개
                            <label class="form-check-label" for="radio1"></label>
                        </div>
                        <div class="form-check" style="color:  #899cb5;">
                            <input type="radio" class="form-check-input" id="radio2" name="is_info_disclosure" value="N">비공개
                            <label class="form-check-label" for="radio2"></label>
                        </div>
                    </div>
                    <input type="hidden" name="role" id="role" value="ROLE_USER">
                    <div class="btnBox">
                        <button type="button"  onclick="submitEditProfile()" style="margin-top: 20px;" id="savebtn">저장</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- 회원탈퇴 모달 -->
    <div id="profileDeleteModal" class="modal" style="display:none;">
        <div class="modal-content" style="width: 20%;">
            <span class="close-button" onclick="closeDeleteProfileModal()">&times;</span>
            <h2 style="text-align: center">회원탈퇴</h2>
            <form method="post" id="deleteProfileForm" onsubmit="return submitDeleteProfile()">
                <div class="joinMain">
                    <div class="joinN">비밀번호</div>
                    <div class="joinI" style="text-align: center;">
                        <input type="password" name="deletePassword" id="deletePassword" placeholder="비밀번호를 입력해주세요" required/>
                    </div>
                    <div class="btnBox">
                        <button type="submit" style="margin-top: 20px;" id="deleteBtn">탈퇴하기</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>