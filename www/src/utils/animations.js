import { deltaEasings } from '@/utils/easings.js';

export const animate = (animation) => {

    if (!animation) {
        return (d) => d
    }
    const animations = animation
        .split(',')
        .map(s => s.replace(/\s+/g, ''))
        .filter(s => s)

    // CSS transforms
    let opacity, rotate, scaleX,scaleY, translateX, translateY

    for(let a of animations) {
        // [type]-[speed]-ease[function]
        const matches = Array.from(a.matchAll(/([a-zA-Z]{2,})(-([0-9\.]{1,}))?(-([a-zA-Z]{2,}))?/g), ([
            _, type, 
            __, speed = 0, 
            ___, easing = 'linear'
        ]) => ({ type, speed: +speed, easing }))
        for (let m of matches){
            let { type, speed, easing } = m
            let easingFn = (delta) => delta // linear
            if (easing in deltaEasings) {
                easingFn = deltaEasings[easing]
            }
            switch (type.toLowerCase()) {
                case 'left':
                    speed = speed || 100
                    translateX = (delta) => -easingFn(delta) * speed
                    break;
                case 'right':
                    speed = speed || 100
                    translateX = (delta) => easingFn(delta) * speed
                    break;
                case 'up':
                    speed = speed || 100
                    translateY = (delta) => -easingFn(delta) * speed
                    break;
                case'down':
                    speed = speed || 100
                    translateY = (delta) => easingFn(delta) * speed
                    break;
                case 'zoomin':
                    speed = speed || 1
                    scaleX = (delta) => Math.pow(speed, easingFn(delta))
                    scaleY = scaleX
                    break;
                case 'zoomout':
                    speed = speed || 1
                    scaleX = (delta) => 1 / Math.pow(speed, easingFn(delta))
                    scaleY = scaleX
                    break;
                case 'fadein':
                    speed = speed || 100
                    opacity = (delta) => (1 - Math.abs(easingFn(delta))) * speed / 100
                    break;
                case 'fadeout':
                    speed = speed || 100
                    opacity = (delta) => Math.abs(easingFn(delta)) * speed / 100
                    break;
                case 'spincw':
                    speed = speed || 360
                    rotate = (delta) => easingFn(delta) * speed
                    break;
                case 'spinccw':
                    speed = speed || 360
                    rotate = (delta) => -easingFn(delta) * speed
                    break;
                default:
                    // noop
                    break; 
            }            
        }
    }

    return (delta) => {
        const scale3dX = (scaleX) ? `${scaleX(delta)}` : '1'
        const scale3dY = (scaleY) ? `${scaleY(delta)}` : '1'
        const scaleT = (scaleX || scaleY)
            ? `scale3d(${scale3dX}, ${scale3dY}, 1) `
            : ``  
        const translate3dX = (translateX) ? `${translateX(delta)}vw` : '0' 
        const translate3dY = (translateY) ? `${translateY(delta)}vh` : '0' 
        const translateT = (translateX || translateY)
            ? `translate3d(${translate3dX}, ${translate3dY}, 0) `
            : ``  
        const opacityT = (opacity)
            ? `opacity: ${opacity(delta)} `
            : ``
        const rotateT = (rotate)
            ? `rotate(${rotate(delta)}deg) `
            : ``

        //transition: transform 100ms 100ms;            
        return `transform: ${scaleT}${translateT}${rotateT}; ${opacityT};`
    }
}
