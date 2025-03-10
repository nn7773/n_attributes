let originalDisplay = "none";

window.addEventListener('message', function (event) {
    if (event.data.action === 'show') {
        const uiContainer = document.querySelector('.container');
        const overlay = document.querySelector('.overlay');

        if (originalDisplay === "none") {
            originalDisplay = getComputedStyle(uiContainer).display;
        }

        uiContainer.style.display = "block";
        overlay.style.display = "block";

        document.getElementById('age').value = event.data.attributes.age || '';
        document.getElementById('height').value = event.data.attributes.height || '';
        document.getElementById('description').value = event.data.attributes.description || '';
    }
});

document.querySelector('.close-btn').addEventListener('click', closeUI);
document.querySelector('.cancel-btn').addEventListener('click', closeUI);

function closeUI() {
    const uiContainer = document.querySelector('.container');
    const overlay = document.querySelector('.overlay');

    uiContainer.style.display = "none";
    overlay.style.display = "none";

    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST',
        body: JSON.stringify({}),
    });
}

document.querySelector('.save-btn').addEventListener('click', function () {
    const age = document.getElementById('age').value;
    const height = document.getElementById('height').value;
    const description = document.getElementById('description').value;

    if (!age || !height || !description) {
        showToast("Please fill in all fields.");
        return;
    }

    fetch(`https://${GetParentResourceName()}/saveAttributes`, {
        method: 'POST',
        body: JSON.stringify({ age, height, description }),
    }).then(response => {
        if (response.ok) {
            closeUI();
        } else {
            showToast("Failed to save attributes. Please try again.");
        }
    });
});

function showToast(message) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.remove();
    }, 3000);
}