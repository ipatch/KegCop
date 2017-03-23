import React, { PropTypes } from 'react';
import ReactDOM from 'react-dom';


// create classes
var NavBar = React.createClass({
  render: function(){
    return(
      <nav className="navbar navbar-inverse navbar-static-top">
        <div className="container">
          <div className="navbar-header">
            <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false">
              <span className="sr-only">Toggle navigation</span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
              <span className="icon-bar"></span>
            </button>
            <NavBrand linkTo={this.props.brand.linkTo} text={this.props.brand.text} />
          </div>
          <div className="collapse navbar-collapse" id="navbar-collapse">
            <NavMenu links={this.props.links} />
          </div>
        </div>
      </nav>
    );
  }
});

var NavBrand = React.createClass({
  render: function(){
    return (
      <Link to={ this.props.linkTo }>
        <span className="navbar-brand">{this.props.text}</span>
      </Link>
    );
  }
});


var NavLinkDropdown = React.createClass({
  render: function(){
    var active = false;
    var links = this.props.links.map(function(link){
      if(link.active){
        active = true;
      }
      return (
        <NavLink key={link.text} linkTo={link.linkTo} text={link.text} active={link.active} icon={link.icon} />
      );
    });
    return (
      <li className={"dropdown " + (active ? "active" : "")}>
        <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
          <span>{Pencil}</span>{this.props.text}

          <span className="caret"></span>
        </a>
        <ul className="dropdown-menu">
          {links}
        </ul>
      </li>
    );
  }
});

var NavLink = React.createClass({
  render: function(){
    return(
      <li className={(this.props.active ? "active" : "")}>

      <Link to={ this.props.linkTo }>
          <span className="NavLink">{this.props.text} {this.props.icon}</span>
      </Link>
      </li>
    );
  }
});

export default NavBar;
