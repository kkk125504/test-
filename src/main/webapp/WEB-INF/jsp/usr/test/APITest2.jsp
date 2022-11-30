<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="REPLY MODIFY" />
<%@ include file="../common/head.jspf" %>
<style>
.card{
background: rgba(0, 0, 0, 0.884);
color: white;
padding: 1.5rem;
border-radius: 30px;
width: 100%;
max-width: 420px;
margin: 1rem;
}
.search{
display: flex;
align-items: center;
justify-content: center;
}
.search button{
margin: 1rem;
border-radius: 50%;
border: none;
height: 2.5rem;
width: 2.5rem;
outline: none;
background-color: rgba(92, 88, 88, 0.644);
color: white;
}
.search button:hover{
background-color: rgb(92, 88, 88);
cursor: pointer;
transition: 0.2s ease-in-out;
}
input.search-bar {
border: none;
outline: none;
padding: 1rem 1rem;
border-radius: 50px;
width: 15rem;
height: 2.5rem;
background-color: rgba(92, 88, 88, 0.644);
color: white;
font-family: inherit;
font-size: 100%;
}
.description{
text-transform: capitalize;
}
</style>
<div class="container mx-auto">
	<div class="card">
		<div class="search">
			<input type="text" class="search-bar" placeholder="Search">
			<button>
				<svg stroke="currentColor" fill="currentColor" stroke-width="0" viewBox="0 0 1024 1024" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg"><path d="M909.6 854.5L649.9 594.8C690.2 542.7 712 479 712 412c0-80.2-31.3-155.4-87.9-212.1-56.6-56.7-132-87.9-212.1-87.9s-155.5 31.3-212.1 87.9C143.2 256.5 112 331.8 112 412c0 80.1 31.3 155.5 87.9 212.1C256.5 680.8 331.8 712 412 712c67 0 130.6-21.8 182.7-62l259.7 259.6a8.2 8.2 0 0 0 11.6 0l43.6-43.5a8.2 8.2 0 0 0 0-11.6zM570.4 570.4C528 612.7 471.8 636 412 636s-116-23.3-158.4-65.6C211.3 528 188 471.8 188 412s23.3-116.1 65.6-158.4C296 211.3 352.2 188 412 188s116.1 23.2 158.4 65.6S636 352.2 636 412s-23.3 116.1-65.6 158.4z"></path></svg>
			</button>
		</div>
		<div class="weather loading">
			<h2 class="city">Weather in Delhi</h2>
			<h1 class="temp">13°C</h1>
			<div class="description">Cloudy</div>
			<div class="humidity">Humid</div>
			<div class="wind">Fast</div>
		</div>
	</div>
</div>	
<script>
	let weather = {
	  "apiKey" : "e5a59b3f594231b48a802fb095c74a97",
	  fetchWeather : function (city) {
	    fetch("https://api.openweathermap.org/data/2.5/weather?q=" + city + "&usits=metric&appid=" + this.apiKey)	    
	    .then((response) => response.json())
	    .then((data) => this.displayWeather(data));
	  }, //api에서 정보를 가져온 후 사용 할 수 있게 data로 넘김
	  displayWeather : function (data) {
	    const {name} = data;
	    const {icon, description} = data.weather[0];
	    const {temp,humidity} = data.main;
	    const {speed} = data.wind;
	    console.log(name,description,icon,temp,humidity,speed);
	    document.querySelector(".city").innerText = "Weather in " + name;
	    document.querySelector(".description").innerText = description;
	    document.querySelector(".temp").innerText = Math.round(temp - 273) + "℃";
	    document.querySelector(".humidity").innerText = "Humidity: " + humidity + "%";
	    document.querySelector(".wind").innerText = "Wind speed: " + speed + "km/h";
	    document.querySelector(".weather").classList.remove("loading");
	  }, //데이터를 어떻게 표기할 지
	  search: function() {
	    this.fetchWeather(document.querySelector(".search-bar").value);
	  } // 검색창에 검색한 도시이름이 fetchWeather에 들어갈 수 있도록
	};
	
	document.querySelector(".search button").addEventListener("click", function () {
		weather.search();
		});
		document.querySelector(".search-bar").addEventListener("keyup",function(event) {
		if (event.key=="Enter") {
			 weather.search()
		}
		});	
</script>

<%@ include file="../common/foot.jspf" %>
