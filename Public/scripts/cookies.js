const cookiesConfirmed = () => {
    $('#cookie-footer').hide();
    const d = new Date();
    d.setTime(d.getTime() + (365 * 24 * 60 * 60 * 1000));
    const expires = `expires=${d.toUTCString()}`;
    document.cookie = `cookies-accepted=true;${expires}`
};