---
slug: desosa-2021-essay1
title: "DESOSA 2021: NVDA's Vision"
authors:
- "Gedeon d' Abreu de Paulo"
- "Robin Cromjongh"
- "Ricardo Jongerius"
- "Hang Ji"
tags: [desosa-2021, 译文]
---

> March 4, 2021
>
> Licensed under CC BY-SA 4.0.

NVDA (Non-visual Desktop Access) is a free and open source Screen Reader for
the Microsoft Windows operating system and many other windows-based third-party applications.
It provides synthetic speech and Braille feedback of the computer screen,
providing a way for blind and visually impaired individuals to
freely and easily access their computers.
The most exciting aspect of NVDA for the users is that it is completely free,
with the founders strongly believing that:

> accessibility and equitable access is a right and
> should not come as an extra cost to a person who is blind or vision impaired.

At the moment, NVDA supports more than 50 languages and
reaches more than 70,000 users in more than 175 countries [^1].

[^1]: The about pages of NV Access: About NVDA and About NV Access.

NVDA was initially started in 2006 by two Australians, Michael Curran and James Teh. At that time,
the two fully blind men founded the not-for-profit organization [NV Access](https://www.nvaccess.org/) to
support the development of the NVDA screen reader in early 2007.
At its core, NVDA is a user-driven project,
with the users being able to contribute to NVDA
if they know Python and are willing to develop add-ons to improve NVDA.


## The domain

As was mentioned, the main aim of NVDA is to make computer content accessible to
blind and visually impaired people.
In order to do this, it is vitally important to consider the output format that
a computer usually uses to provide feedback to the user,
and the input methods that can be used to interact with a computer.

Most digital content is in the form of text and images that is displayed on the screen.
Blind and other visually impaired individuals need a way alternative to vision to
successfully interact with a computer.
To do this, the system needs to convert the default output format to one of
the other senses, such as sound or touch.

The most common ways to interact with a computer are through keyboard and mouse.
However, visually impaired people also use Braille keyboards to interact with computers.
The system must support these different input methods and
aid a visually impaired user in interacting with the system by
giving a different kind of feedback than visual.


## NVDA’s capabilities

To fulfill these main requirements, NVDA offers the following extended set of functionalities[^2]:

[^2]: The NVDA User Guide.

- Text is read out loud when hovering over it with the cursor or
- selecting it with keyboard shortcuts.
- Text is converted to be displayed on a Braille display.
- Text in images is recognised and similarly conveyed.
- There is support for many languages.
- There is support for different voices and speech synthesisers.
- It works on many different applications, as well as the Windows interfaces.
- It can run from a flash drive for portability.
- There is auditory feedback on the position of the mouse and
    the current focus of the system (e.g. what window or textfield).

Now that we have seen what NVDA can do,
let us take a closer look at the context in which NVDA operates.

## Some context

There are two different perspectives on the context of NVDA.
These perspectives illustrate how NVDA interacts with the external world and its related systems.

Let us begin with the first perspective,
which displays the cooperation between NVDA and the external world:

![desosa-2021-essay1-ExternalWorld.png](https://cdn.sa.net/2025/06/05/6NEUdwhnP39GBYV.png)
Figure: System Context View of the External World

The above graph shows different context branches, with the following explanation:

- NVDA is **used by** blind and visually impaired individuals.
- NVDA **runs on** Windows operating systems.
- NVDA provides **documentation** for both users and developers.
- NVDA is **developed by** NV Access and contributors from GitHub.
- NVDA **is written** in Python.
- It is hard to point out the **competitors** of NVDA,
    a brilliant software aiming to help blind and
    visually impaired people easily access the computer screen at no cost.
    [JAWS][JAWS] might be one of the competitors, however, it is expensive.
- NVDA uses mailing lists to **communicate** with users and developers.
    It can also be reached from NV Access.
    NVDA is also working on a [Community Wiki][wiki] to bring users and developers together.
    The second perspective presents a system context view describing
    how NVDA interfaces with existing systems.

[JAWS]: https://www.freedomscientific.com/products/software/jaws/
[wiki]: https://github.com/nvaccess/nvda-community/wiki


![desosa-2021-essay1-ExistingSystem.png](https://cdn.sa.net/2025/06/05/yirw3lOgfc1Jd7H.png)
Figure: System Context View of Existing System

The above graph shows a brief system context view of NVDA, with the following explanation:

- As a Windows OS screen reader, NVDA is able to **read content from**
    popular applications including web browsers, email clients,
    internet chat programs and office suites.
    Additionally, it also provides its own features to improve accessibility for many applications.
    For example, it is able to automatically announce appropriate row and column headers
    when navigating Microsoft Excel worksheets.
- **Users interact with** NVDA through keyboard, mouse and touch gestures on touchscreens.
- To improve the content recognition functionality and
    **recognize text from images or inaccessible applications**,
    NVDA supports Windows 10 optical character recognition (OCR) functionality.
- NVDA is able to work with add-ons to enhance accessibility and improve flexibility.
    These [add-ons](https://addons.nvda-project.org/index.en.html) are all provided by the NVDA community.
- NVDA supports various speech synthesizers to **provide audio output**.
    At the moment, the [eSpeak NG](https://github.com/espeak-ng/espeak-ng) system
    is built into NVDA as a default speech synthesizer.
    NVDA also supports many other speech synthesizer systems and APIs.
    For example, the Microsoft Speech API (version 4,5) and Microsoft Speech platform.
- NVDA supports various Braille displays to **provide Braille output**.
    These Braille displays include Handy Tech displays, Supper Braille,
    Nattiq nBraille displays and many others.


## The stakeholders

Now that we have given a bit of context around NVDA,
let us take a closer look at the many associated parties.
These include not only those that are supported by NVDA,
but also those which support NVDA. These stakeholders are the:

### Businesses

NVDA is used by [many businesses around the world](https://www.nvaccess.org/partners/).
This includes businesses that might want to help their own employees (e.g. Google)
and those which provide services for employees of other organizations (e.g. Babbage).
For these businesses, NVDA needs to be secure so that it can be trusted within their networks,
well documented, and easily configurable so that it can be tailored to
the needs of each business or employee.
Next to the businesses, there are the:

### Contributors

The contributors are the thousands of translators,
who have already helped to translate NVDA into over [55 different languages](https://www.nvaccess.org/about-nv-access/),
and developers, who develop support for additional functionalities.
The translators require an easy way of adding more translations,
while the developers need to have an open source and
maintainable code base which they can easily extend for different use cases.

Finally, it should be easy to see that
the main and most important stakeholder of NVDA are the:

### End users

NVDA was made by the blind, for the blind.
However, NVDA is not solely for the completely blind,
it is also incredibly useful for partially blind and deafblind individuals.
For all these users, NVDA needs to be able to support common use cases,
such as reading a document, and support various applications,
such as Microsoft Excel.
Finally, it must be able to provide support to its users regardless of their country,
desired method of input or method of output.


## Key quality attributes

To satisfy all of these stakeholders, there are many quality attributes that NVDA needs to meet.
In order to give an effective overview of these attributes,
we will use the quality attributes which Cesare Pautasso formulated in his book,
Software Architecture[^3].
In the end, all of the selected attributes relate back to
NVDA’s vision of providing visually impaired individuals around the world access to the digital world.
Thus, the quality attributes are related to the usability of NVDA,
how well it can handle change, and privacy.

[^3]: Pautasso, Cesare. *Software Architecture: visual lecture notes*. (2020)

### Accessibility & Internationalization

We have established that the most important stakeholder of NVDA,
are the disabled end users.
Thus, one of the most important quality attributes pertains to the usability of NVDA.
Pautasso identifies 6 properties of usability, two of which are the most relevant,
namely accessibility and internationalization.
NVDA needs to be as accessible as possible to users across the disability spectrum,
as it is one of the main gateways to the digital world for its users.
Furthermore, in order to service users across the world,
it should also be properly internationalized and usable for
users across different languages and locales.

### Configurability & Extensibility

Another important quality attribute of NVDA, is its configurability.
The users need to be able to configure the behavior of their speech synthesizer,
for example by defining how certain symbols should be spoken.
Additionally, different input and output methods need to be configurable,
such as a refreshable braille display, which is especially important for deafblind users.

In order to ensure that NVDA keeps up with the constantly changing digital world,
it should also be easily extendable so that developers can efficiently add
new functionalities for visually impaired users.
Additionally, it should also be easy for contributors to add new language information.

### Privacy

NVDA serves as the main gateway through which its users can interact with their computer.
Thus, it is in a prime position to collect an incredible amount of usage data about its users.
To avoid this, privacy is an important attribute which should be respected.
As this is a crucial point, we will touch on it further when discussing ethical considerations.


## What’s next?

The future direction of NVDA is not clearly defined by a product roadmap.
Regarding the short-term goals, the core developers [have asked](https://github.com/nvaccess/nvda/issues/11006) to
temporarily hold off on creating new features or enhancements to NVDA.
They did this to first address the existing backlog of pull requests.
It is important to properly manage all open pull requests,
in order to maintain a clear overview and apparent direction of the project.

The long-term roadmap is more difficult to establish,
as the project does not have one outlined anywhere.
There are a few open projects on their Github, which gives a rough idea of what they want to achieve.
Some highlights include enhancements to the status bar,
upgrading to Python 3.8 and improved support for Microsoft’s UI Automation (UIA) in Word and Outlook.
UIA is used to manipulate the different user interface elements of various applications.


## Ethical considerations

We feel the ethical foundation of NVDA is clearly visible.
It is a screen reader which aids visually impaired people,
while being completely free.
The main goal of NVDA is to be of service to its users,
not generate revenue from them.
This is further supported by the organisational structure of NV Access:
a non-profit organisation recognised as a charitable institution.
While they do offer some paid services and books,
most of their revenue comes from donations.

Its official statement of purpose is to:

> lower the economic and social barriers associated with
> accessing Information Technology for people who are Blind or Vision Impaired.

In order to ensure this ambition is kept,
at least 33% of NV Access' Board of Directors must be blind or visually impaired[^4].
In our opinion, all of the aforementioned points combined inspires plenty of
confidence in the ethical fundamentals of NV Access.

[^4]: The about page of NV Access: https://www.nvaccess.org/about-nv-access/.

### Privacy

NVDA does not collect any personally identifiable information.
There are only two optional settings which could transfer information to NV Access:

- The first option is the automatically check for updates.
    Enabling this allows some information about the system to be sent,
    such as the current NVDA version, which OS is being used and whether it is 64 or 32 bit.
- The second option allows NVDA to collect some usage statistics from the update check.
    These include country of origin, the interface language,
    whether it is the portable version of NVDA,
    and which synthesizer or Braille display is used.
    When these options are unchecked, NVDA does not require any internet access,
    with no impact on performance or functionality of the program whatsoever.


## Conclusion

In conclusion, NVDA is an application with the noble goal of
helping visually impaired individuals around the world to interact with their computers.
It is used by businesses and individuals alike, and relies on dozens of contributors.
Its key attributes include accessibility and extensibility,
while also keeping privacy in mind.
We feel that NV Access has created a great product which continues to
have a truly positive impact on the world!
